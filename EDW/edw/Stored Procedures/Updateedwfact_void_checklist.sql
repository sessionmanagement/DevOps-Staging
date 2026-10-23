
CREATE procedure [edw].[Updateedwfact_void_checklist] 

/**************************************************************************************************************
 Procedure	[edw].[Updateedwdim_employee] 
 Author		Greg Nuthall
 Created	2025-02-28	
 Purpose	Property void category vw_zav_voidchecklist to populate fact_void_checklist	
 =========================================================================================================
		
--REVISIONS:
--Version	 Date		   Author			Description
---------	 ------------  ---------------	--------------------------
--1.0		 2025-02-28		Mike Gencic		Initial version
--1.1        2025-04-30		Greg Nuthall	Created date and status name from vw_OptionsetMetadata
--1.2		 2025-01-05		Greg Nuthall	Added null clauses to avoid irrelevant inserts
--1.3        2025-05-06     Manish Singh    Changed Prefix of Audit columns from EDW to DWH
--1.4        2025-11-06     Greg Nuthall    Changed join on inserts to cater for null values in unique identifiers
--****************************************************************************************************************/

	@pBatchID int, 
	@pIndexRebuildThreshold int,
	@pOutputParamsAsDataset int = 0,
	@pErrorRecords int = null OUTPUT, 
	@pInsertRecords int = null OUTPUT, 
	@pUpdateRecords int = null OUTPUT, 
	@pDeleteRecords int = null OUTPUT,
	@pCompleted int = null OUTPUT,
	@pTargetRecords int = null OUTPUT,
	@pErrorMessage varchar(MAX) = null OUTPUT
as 

begin

	set nocount on;
	set xact_abort on;

	-- Variables
	declare @batchID int = @pBatchID;
	declare @SourceSystem nvarchar(120) = 'Zavanti.vw_zav_voidchecklist';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	declare @SystemEffectiveFrom datetime = @systemCurrentDate;
	declare @SystemEffectiveTo datetime = dateadd(second,-1,@SystemEffectiveFrom);
	declare @SystemDefaultEffectiveFrom datetime = '1 January 1900';
	declare @SystemDefaultEffectiveTo datetime = '31 December 2999 23:59:59';

	-- Do not run if there are no records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLfact_void_checklist];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[fact_void_checklist];

		-- Select success details
		select
			 @pErrorRecords = 0
			,@pInsertRecords = 0
			,@pUpdateRecords = 0
			,@pDeleteRecords = 0
			,@pCompleted = 1
			,@pTargetRecords = @targetRecords	

		if (@pOutputParamsAsDataset = 1)
		begin
			-- Select return parameters as a dataset
			select @pErrorRecords	as ErrorRecords,
					@pInsertRecords as InsertRecords,
					@pUpdateRecords as UpdateRecords,
					@pDeleteRecords as DeleteRecords,
					@pCompleted		as Completed,
					@targetRecords	as TargetRecords,
					@pErrorMessage as ErrorMessage;
		end;

		return;
	end;

	if( object_id( 'tempdb..#SummaryOfChanges') is not null ) drop table #SummaryOfChanges;
	create table #SummaryOfChanges
	(	
		 [void_checklist_id] uniqueidentifier null
		,[void_checklist_offered_property_id] uniqueidentifier null
		,[void_checklist_property_id] uniqueidentifier null
		,[void_checklist_vacated_tenancy_id] uniqueidentifier null
		,[void_checklist_void_category_id] uniqueidentifier null
		,[MergeAction] varchar(10)
	);
	begin transaction;

	begin try
		if( not exists (select top(1) 1 from [edw].[fact_void_checklist]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[fact_void_checklist]
			(    [dim_property_key]
				,[dim_property_tenancy_key]
				,[dim_offered_property_key]
				,[dim_void_category_key] 
				,[void_checklist_id] 
				,[void_checklist_status] 
				,[void_checklist_status_name]
				,[void_checklist_offered_property_id] 
				,[void_checklist_offered_property_entity_type] 
				,[void_checklist_property_id] 
				,[void_checklist_property_entity_type] 
				,[void_checklist_vacated_tenancy_id] 
				,[void_checklist_vacated_tenancy_entity_type] 
				,[void_checklist_void_category_id] 
				,[void_checklist_void_category_entity_type] 
				,[void_checklist_owner_id] 
				,[void_checklist_owner_entity_type] 
				,[void_checklist_crba8_comments]
				,[void_checklist_created_on]
				,[void_checklist_owner_id_name] 
				,[void_checklist_all_compliance_issues_completed] 
				,[void_checklist_assessment_completed_and_scope_of_works_understood] 
				,[void_checklist_assessment_scoping] 
				,[void_checklist_bond_recovery_forms_completed] 
				,[void_checklist_bos_msd_approved_property] 
				,[void_checklist_bos_updated_vacancy_listed] 
				,[void_checklist_bos_updated_vacate_date] 
				,[void_checklist_car_parking_provisioned] 
				,[void_checklist_confirm_tenancy_accepted_in_bos] 
				,[void_checklist_damage_assessment] 
				,[void_checklist_date_bond_form_signed_given_to_agent_owner] 
				,[void_checklist_date_end_of_hold_for_property_redevelopment] 
				,[void_checklist_date_finance_notified_lease_property_handed_back] 
				,[void_checklist_date_first_offer_made] 
				,[void_checklist_date_hud_notified_of_tenancy_tribunal_application] 
				,[void_checklist_date_key_received_from_tenant] 
				,[void_checklist_date_keys_returned_from_contractor] 
				,[void_checklist_date_keys_returned_from_specialist_contractor] 
				,[void_checklist_date_keys_sent_to_specialist_contractor] 
				,[void_checklist_date_keys_surrendered_to_agent_owner] 
				,[void_checklist_date_keys_to_contractor] 
				,[void_checklist_date_keys_to_loss_adjuster_insurance] 
				,[void_checklist_date_keys_to_property_team] 
				,[void_checklist_date_keys_to_tenancy_team_to_allocate] 
				,[void_checklist_date_msd_notified_of_pending_termination] 
				,[void_checklist_date_notice_received] 
				,[void_checklist_date_offer_confirmed_accepted] 
				,[void_checklist_date_of_final_inspection_after_keys_received] 
				,[void_checklist_date_of_handover] 
				,[void_checklist_date_possession_granted] 
				,[void_checklist_date_post_work_inspection_completed] 
				,[void_checklist_date_pre_vacate_inspection] 
				,[void_checklist_date_second_offer_made] 
				,[void_checklist_date_tam_gained_access_abandoned_property] 
				,[void_checklist_date_tenancy_terminated] 
				,[void_checklist_date_work_scope_completed] 
				,[void_checklist_name] 
				,[void_checklist_offered_property_name] 
				,[void_checklist_property_name] 
				,[void_checklist_property_to_be_redeveloped] 
				,[void_checklist_property_units_submitted_to_bos_approved] 
				,[void_checklist_refurbishment_completed] 
				,[void_checklist_repairs_completed] 
				,[void_checklist_residential_tenancy_agreement_prepared] 
				,[void_checklist_rubbish_and_equipment_removed] 
				,[void_checklist_safety_check] 
				,[void_checklist_safety_check_completed] 
				,[void_checklist_service_name_has_been_entered_at_property] 
				,[void_checklist_shortlist_created] 
				,[void_checklist_signed_lease_or_agreement_received] 
				,[void_checklist_subprogram_program_entered_at_property] 
				,[void_checklist_target_completion_date_vacant] 
				,[void_checklist_target_completion_date_void] 
				,[void_checklist_tenancy_resolved_and_exited] 
				,[void_checklist_tenant_improvements_scoped_and_agreed] 
				,[void_checklist_upcoming_maintenance_jobs_booked] 
				,[void_checklist_utilities_connections_recorded_and_setup_if_applicable] 
				,[void_checklist_utilities_disconnected] 
				,[void_checklist_vacated_tenancy_name] 
				,[void_checklist_void_category_name] 
				,[void_checklist_void_checklist_id] 
				,[void_checklist_void_completed_date] 
				,[void_checklist_water_meter_readings_and_numbers] 
				,[void_checklist_is_delete_flag] 
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
			)
			select
				 src.[dim_property_key]
				,src.[dim_property_tenancy_key]
				,src.[dim_offered_property_key]
				,src.[dim_void_category_key] 
				,src.[void_checklist_id] 
				,src.[void_checklist_status] 
				,src.[void_checklist_status_name]
				,src.[void_checklist_offered_property_id] 
				,src.[void_checklist_offered_property_entity_type] 
				,src.[void_checklist_property_id] 
				,src.[void_checklist_property_entity_type] 
				,src.[void_checklist_vacated_tenancy_id] 
				,src.[void_checklist_vacated_tenancy_entity_type] 
				,src.[void_checklist_void_category_id] 
				,src.[void_checklist_void_category_entity_type] 
				,src.[void_checklist_owner_id] 
				,src.[void_checklist_owner_entity_type] 
				,src.[void_checklist_crba8_comments] 
				,src.[void_checklist_created_on]
				,src.[void_checklist_owner_id_name] 
				,src.[void_checklist_all_compliance_issues_completed] 
				,src.[void_checklist_assessment_completed_and_scope_of_works_understood] 
				,src.[void_checklist_assessment_scoping] 
				,src.[void_checklist_bond_recovery_forms_completed] 
				,src.[void_checklist_bos_msd_approved_property] 
				,src.[void_checklist_bos_updated_vacancy_listed] 
				,src.[void_checklist_bos_updated_vacate_date] 
				,src.[void_checklist_car_parking_provisioned] 
				,src.[void_checklist_confirm_tenancy_accepted_in_bos] 
				,src.[void_checklist_damage_assessment] 
				,src.[void_checklist_date_bond_form_signed_given_to_agent_owner] 
				,src.[void_checklist_date_end_of_hold_for_property_redevelopment] 
				,src.[void_checklist_date_finance_notified_lease_property_handed_back] 
				,src.[void_checklist_date_first_offer_made] 
				,src.[void_checklist_date_hud_notified_of_tenancy_tribunal_application] 
				,src.[void_checklist_date_key_received_from_tenant] 
				,src.[void_checklist_date_keys_returned_from_contractor] 
				,src.[void_checklist_date_keys_returned_from_specialist_contractor] 
				,src.[void_checklist_date_keys_sent_to_specialist_contractor] 
				,src.[void_checklist_date_keys_surrendered_to_agent_owner] 
				,src.[void_checklist_date_keys_to_contractor] 
				,src.[void_checklist_date_keys_to_loss_adjuster_insurance] 
				,src.[void_checklist_date_keys_to_property_team] 
				,src.[void_checklist_date_keys_to_tenancy_team_to_allocate] 
				,src.[void_checklist_date_msd_notified_of_pending_termination] 
				,src.[void_checklist_date_notice_received] 
				,src.[void_checklist_date_offer_confirmed_accepted] 
				,src.[void_checklist_date_of_final_inspection_after_keys_received] 
				,src.[void_checklist_date_of_handover] 
				,src.[void_checklist_date_possession_granted] 
				,src.[void_checklist_date_post_work_inspection_completed] 
				,src.[void_checklist_date_pre_vacate_inspection] 
				,src.[void_checklist_date_second_offer_made] 
				,src.[void_checklist_date_tam_gained_access_abandoned_property] 
				,src.[void_checklist_date_tenancy_terminated] 
				,src.[void_checklist_date_work_scope_completed] 
				,src.[void_checklist_name] 
				,src.[void_checklist_offered_property_name] 
				,src.[void_checklist_property_name] 
				,src.[void_checklist_property_to_be_redeveloped] 
				,src.[void_checklist_property_units_submitted_to_bos_approved] 
				,src.[void_checklist_refurbishment_completed] 
				,src.[void_checklist_repairs_completed] 
				,src.[void_checklist_residential_tenancy_agreement_prepared] 
				,src.[void_checklist_rubbish_and_equipment_removed] 
				,src.[void_checklist_safety_check] 
				,src.[void_checklist_safety_check_completed] 
				,src.[void_checklist_service_name_has_been_entered_at_property] 
				,src.[void_checklist_shortlist_created] 
				,src.[void_checklist_signed_lease_or_agreement_received] 
				,src.[void_checklist_subprogram_program_entered_at_property] 
				,src.[void_checklist_target_completion_date_vacant] 
				,src.[void_checklist_target_completion_date_void] 
				,src.[void_checklist_tenancy_resolved_and_exited] 
				,src.[void_checklist_tenant_improvements_scoped_and_agreed] 
				,src.[void_checklist_upcoming_maintenance_jobs_booked] 
				,src.[void_checklist_utilities_connections_recorded_and_setup_if_applicable] 
				,src.[void_checklist_utilities_disconnected] 
				,src.[void_checklist_vacated_tenancy_name] 
				,src.[void_checklist_void_category_name] 
				,src.[void_checklist_void_checklist_id] 
				,src.[void_checklist_void_completed_date] 
				,src.[void_checklist_water_meter_readings_and_numbers] 
				,src.[void_checklist_is_delete_flag] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLfact_void_checklist] as src;
		end else begin
			merge into [edw].[fact_void_checklist] as trg
			using 
			(
				select
				src.[dim_property_key]
				,src.[dim_property_tenancy_key]
				,src.[dim_offered_property_key]
				,src.[dim_void_category_key] 
				,src.[void_checklist_id] 
				,src.[void_checklist_status]
				,src.[void_checklist_status_name]
				,src.[void_checklist_offered_property_id] 
				,src.[void_checklist_offered_property_entity_type] 
				,src.[void_checklist_property_id] 
				,src.[void_checklist_property_entity_type] 
				,src.[void_checklist_vacated_tenancy_id] 
				,src.[void_checklist_vacated_tenancy_entity_type] 
				,src.[void_checklist_void_category_id] 
				,src.[void_checklist_void_category_entity_type] 
				,src.[void_checklist_owner_id] 
				,src.[void_checklist_owner_entity_type] 
				,src.[void_checklist_crba8_comments] 
				,src.[void_checklist_created_on]
				,src.[void_checklist_owner_id_name] 
				,src.[void_checklist_all_compliance_issues_completed] 
				,src.[void_checklist_assessment_completed_and_scope_of_works_understood] 
				,src.[void_checklist_assessment_scoping] 
				,src.[void_checklist_bond_recovery_forms_completed] 
				,src.[void_checklist_bos_msd_approved_property] 
				,src.[void_checklist_bos_updated_vacancy_listed] 
				,src.[void_checklist_bos_updated_vacate_date] 
				,src.[void_checklist_car_parking_provisioned] 
				,src.[void_checklist_confirm_tenancy_accepted_in_bos] 
				,src.[void_checklist_damage_assessment] 
				,src.[void_checklist_date_bond_form_signed_given_to_agent_owner] 
				,src.[void_checklist_date_end_of_hold_for_property_redevelopment] 
				,src.[void_checklist_date_finance_notified_lease_property_handed_back] 
				,src.[void_checklist_date_first_offer_made] 
				,src.[void_checklist_date_hud_notified_of_tenancy_tribunal_application] 
				,src.[void_checklist_date_key_received_from_tenant] 
				,src.[void_checklist_date_keys_returned_from_contractor] 
				,src.[void_checklist_date_keys_returned_from_specialist_contractor] 
				,src.[void_checklist_date_keys_sent_to_specialist_contractor] 
				,src.[void_checklist_date_keys_surrendered_to_agent_owner] 
				,src.[void_checklist_date_keys_to_contractor] 
				,src.[void_checklist_date_keys_to_loss_adjuster_insurance] 
				,src.[void_checklist_date_keys_to_property_team] 
				,src.[void_checklist_date_keys_to_tenancy_team_to_allocate] 
				,src.[void_checklist_date_msd_notified_of_pending_termination] 
				,src.[void_checklist_date_notice_received] 
				,src.[void_checklist_date_offer_confirmed_accepted] 
				,src.[void_checklist_date_of_final_inspection_after_keys_received] 
				,src.[void_checklist_date_of_handover] 
				,src.[void_checklist_date_possession_granted] 
				,src.[void_checklist_date_post_work_inspection_completed] 
				,src.[void_checklist_date_pre_vacate_inspection] 
				,src.[void_checklist_date_second_offer_made] 
				,src.[void_checklist_date_tam_gained_access_abandoned_property] 
				,src.[void_checklist_date_tenancy_terminated] 
				,src.[void_checklist_date_work_scope_completed] 
				,src.[void_checklist_name] 
				,src.[void_checklist_offered_property_name] 
				,src.[void_checklist_property_name] 
				,src.[void_checklist_property_to_be_redeveloped] 
				,src.[void_checklist_property_units_submitted_to_bos_approved] 
				,src.[void_checklist_refurbishment_completed] 
				,src.[void_checklist_repairs_completed] 
				,src.[void_checklist_residential_tenancy_agreement_prepared] 
				,src.[void_checklist_rubbish_and_equipment_removed] 
				,src.[void_checklist_safety_check] 
				,src.[void_checklist_safety_check_completed] 
				,src.[void_checklist_service_name_has_been_entered_at_property] 
				,src.[void_checklist_shortlist_created] 
				,src.[void_checklist_signed_lease_or_agreement_received] 
				,src.[void_checklist_subprogram_program_entered_at_property] 
				,src.[void_checklist_target_completion_date_vacant] 
				,src.[void_checklist_target_completion_date_void] 
				,src.[void_checklist_tenancy_resolved_and_exited] 
				,src.[void_checklist_tenant_improvements_scoped_and_agreed] 
				,src.[void_checklist_upcoming_maintenance_jobs_booked] 
				,src.[void_checklist_utilities_connections_recorded_and_setup_if_applicable] 
				,src.[void_checklist_utilities_disconnected] 
				,src.[void_checklist_vacated_tenancy_name] 
				,src.[void_checklist_void_category_name] 
				,src.[void_checklist_void_checklist_id] 
				,src.[void_checklist_void_completed_date] 
				,src.[void_checklist_water_meter_readings_and_numbers] 
				,src.[void_checklist_is_delete_flag] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLfact_void_checklist] as src
			) as src on (src.[void_checklist_id] = trg.[void_checklist_id] and isnull(src.[void_checklist_offered_property_id],CAST(0x0 AS UNIQUEIDENTIFIER)) = isnull(trg.[void_checklist_offered_property_id],CAST(0x0 AS UNIQUEIDENTIFIER)) and isnull(src.[void_checklist_property_id],CAST(0x0 AS UNIQUEIDENTIFIER)) = isnull(trg.[void_checklist_property_id],CAST(0x0 AS UNIQUEIDENTIFIER)) and isnull(src.[void_checklist_vacated_tenancy_id],CAST(0x0 AS UNIQUEIDENTIFIER)) = isnull(trg.[void_checklist_vacated_tenancy_id],CAST(0x0 AS UNIQUEIDENTIFIER)) and isnull(src.[void_checklist_void_category_id],CAST(0x0 AS UNIQUEIDENTIFIER)) = isnull(trg.[void_checklist_void_category_id],CAST(0x0 AS UNIQUEIDENTIFIER)) and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 	
			--void_checklist_offered_property_id
			--void_checklist_offered_property_entity_type
			--void_checklist_date_keys_to_tenancy_team_to_allocate
			--void_checklist_date_offer_confirmed_accepted
			--void_checklist_offered_property_name
			--void_checklist_target_completion_date_vacant
			--void_checklist_target_completion_date_void
	
			select src.[void_checklist_status]
				, isnull(src.[void_checklist_status_name],'XXXX') as void_checklist_status_name
				, isnull(src.[void_checklist_offered_property_entity_type],'XXXX') as void_checklist_offered_property_entity_type
				, isnull(src.[void_checklist_property_entity_type],'XXXX') as void_checklist_property_entity_type
				, src.[void_checklist_vacated_tenancy_entity_type]
				, isnull(src.[void_checklist_void_category_entity_type],'XXXX') as void_checklist_void_category_entity_type
				, src.[void_checklist_owner_id]
				, src.[void_checklist_owner_entity_type]
				, isnull(src.[void_checklist_crba8_comments],'XXXX') as void_checklist_crba8_comments
				, src.[void_checklist_created_on]
				, src.[void_checklist_owner_id_name]
				, isnull(src.[void_checklist_all_compliance_issues_completed],'1900-01-01') as void_checklist_all_compliance_issues_completed
				, isnull(src.[void_checklist_assessment_completed_and_scope_of_works_understood],'1900-01-01') as void_checklist_assessment_completed_and_scope_of_works_understood
				, isnull(src.[void_checklist_assessment_scoping],'1900-01-01') as void_checklist_assessment_scoping
				, isnull(src.[void_checklist_bond_recovery_forms_completed],'1900-01-01') as [void_checklist_bond_recovery_forms_completed]
				, isnull(src.[void_checklist_bos_msd_approved_property],'1900-01-01') as [void_checklist_bos_msd_approved_property]
				, isnull(src.[void_checklist_bos_updated_vacancy_listed],'1900-01-01') as [void_checklist_bos_updated_vacancy_listed]
				, isnull(src.[void_checklist_bos_updated_vacate_date],'1900-01-01') as [void_checklist_bos_updated_vacate_date]
				, isnull(src.[void_checklist_car_parking_provisioned],'1900-01-01') as [void_checklist_car_parking_provisioned]
				, isnull(src.[void_checklist_confirm_tenancy_accepted_in_bos],'1900-01-01') as [void_checklist_confirm_tenancy_accepted_in_bos]
				, isnull(src.[void_checklist_damage_assessment],'1900-01-01') as [void_checklist_damage_assessment]
				, isnull(src.[void_checklist_date_bond_form_signed_given_to_agent_owner],'1900-01-01') as [void_checklist_date_bond_form_signed_given_to_agent_owner]
				, isnull(src.[void_checklist_date_end_of_hold_for_property_redevelopment],'1900-01-01') as [void_checklist_date_end_of_hold_for_property_redevelopment]
				, isnull(src.[void_checklist_date_finance_notified_lease_property_handed_back],'1900-01-01') as [void_checklist_date_finance_notified_lease_property_handed_back]
				, isnull(src.[void_checklist_date_first_offer_made],'1900-01-01') as [void_checklist_date_first_offer_made]
				, isnull(src.[void_checklist_date_hud_notified_of_tenancy_tribunal_application],'1900-01-01') as [void_checklist_date_hud_notified_of_tenancy_tribunal_application]
				, isnull(src.[void_checklist_date_key_received_from_tenant],'1900-01-01') as [void_checklist_date_key_received_from_tenant]
				, isnull(src.[void_checklist_date_keys_returned_from_contractor],'1900-01-01') as [void_checklist_date_keys_returned_from_contractor]
				, isnull(src.[void_checklist_date_keys_returned_from_specialist_contractor],'1900-01-01') as [void_checklist_date_keys_returned_from_specialist_contractor]
				, isnull(src.[void_checklist_date_keys_sent_to_specialist_contractor],'1900-01-01') as [void_checklist_date_keys_sent_to_specialist_contractor]
				, isnull(src.[void_checklist_date_keys_surrendered_to_agent_owner],'1900-01-01') as [void_checklist_date_keys_surrendered_to_agent_owner]
				, isnull(src.[void_checklist_date_keys_to_contractor],'1900-01-01') as [void_checklist_bos_updated_vacate_date]
				, isnull(src.[void_checklist_date_keys_to_loss_adjuster_insurance],'1900-01-01') as [void_checklist_date_keys_to_loss_adjuster_insurance]
				, isnull(src.[void_checklist_date_keys_to_property_team],'1900-01-01') as [void_checklist_date_keys_to_property_team]
				, isnull(src.[void_checklist_date_keys_to_tenancy_team_to_allocate],'1900-01-01') as [void_checklist_bos_updated_vacate_date]
				, isnull(src.[void_checklist_date_msd_notified_of_pending_termination],'1900-01-01') as [void_checklist_date_msd_notified_of_pending_termination]
				, isnull(src.[void_checklist_date_notice_received],'1900-01-01') as [void_checklist_date_notice_received]
				, isnull(src.[void_checklist_date_offer_confirmed_accepted],'1900-01-01') as [void_checklist_date_offer_confirmed_accepted]
				, isnull(src.[void_checklist_date_of_final_inspection_after_keys_received],'1900-01-01') as [void_checklist_date_of_final_inspection_after_keys_received]
				, isnull(src.[void_checklist_date_of_handover],'1900-01-01') as [void_checklist_date_of_handover]
				, isnull(src.[void_checklist_date_possession_granted],'1900-01-01') as [void_checklist_date_possession_granted]
				, isnull(src.[void_checklist_date_post_work_inspection_completed],'1900-01-01') as [void_checklist_date_post_work_inspection_completed]
				, isnull(src.[void_checklist_date_pre_vacate_inspection],'1900-01-01') as [void_checklist_date_pre_vacate_inspection]
				, isnull(src.[void_checklist_date_second_offer_made],'1900-01-01') as [void_checklist_date_second_offer_made]
				, isnull(src.[void_checklist_date_tam_gained_access_abandoned_property],'1900-01-01') as [void_checklist_date_tam_gained_access_abandoned_property]
				, isnull(src.[void_checklist_date_tenancy_terminated],'1900-01-01') as [void_checklist_date_tenancy_terminated]
				, isnull(src.[void_checklist_date_work_scope_completed],'1900-01-01') as [void_checklist_date_work_scope_completed]
				, src.[void_checklist_name]
				, isnull(src.[void_checklist_offered_property_name],'XXXX')
				, isnull(src.[void_checklist_property_name],'XXXX')
				, isnull(src.[void_checklist_property_to_be_redeveloped],'1900-01-01')
				, isnull(src.[void_checklist_property_units_submitted_to_bos_approved],'1900-01-01')
				, isnull(src.[void_checklist_refurbishment_completed],'1900-01-01')
				, isnull(src.[void_checklist_repairs_completed],'1900-01-01')
				, isnull(src.[void_checklist_residential_tenancy_agreement_prepared],'1900-01-01')
				, isnull(src.[void_checklist_rubbish_and_equipment_removed],'1900-01-01')
				, isnull(src.[void_checklist_safety_check],'1900-01-01')
				, isnull(src.[void_checklist_safety_check_completed],'1900-01-01')
				, isnull(src.[void_checklist_service_name_has_been_entered_at_property],'1900-01-01')
				, isnull(src.[void_checklist_shortlist_created],'1900-01-01')
				, isnull(src.[void_checklist_signed_lease_or_agreement_received],'1900-01-01')
				, isnull(src.[void_checklist_subprogram_program_entered_at_property],'1900-01-01')
				, isnull(src.[void_checklist_target_completion_date_vacant],'1900-01-01')
				, isnull(src.[void_checklist_target_completion_date_void],'1900-01-01')
				, isnull(src.[void_checklist_tenancy_resolved_and_exited],'1900-01-01')
				, isnull(src.[void_checklist_tenant_improvements_scoped_and_agreed],'1900-01-01')
				, isnull(src.[void_checklist_upcoming_maintenance_jobs_booked],'1900-01-01')
				, isnull(src.[void_checklist_utilities_connections_recorded_and_setup_if_applicable],'1900-01-01')
				, isnull(src.[void_checklist_utilities_disconnected],'1900-01-01')
				, isnull(src.[void_checklist_vacated_tenancy_name],'XXXX')
				, src.[void_checklist_void_category_name]
				, src.[void_checklist_void_checklist_id]
				, isnull(src.[void_checklist_void_completed_date],'1900-01-01')
				, isnull(src.[void_checklist_water_meter_readings_and_numbers],'1900-01-01')
				, src.[void_checklist_is_delete_flag]
				, case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end

				except
				select trg.[void_checklist_status]
				, isnull(trg.[void_checklist_status_name],'XXXX') as void_checklist_status_name
				, isnull(trg.[void_checklist_offered_property_entity_type],'XXXX') as void_checklist_offered_property_entity_type
				, isnull(trg.[void_checklist_property_entity_type],'XXXX') as void_checklist_property_entity_type
				, trg.[void_checklist_vacated_tenancy_entity_type]
				, isnull(trg.[void_checklist_void_category_entity_type],'XXXX') as void_checklist_void_category_entity_type
				, trg.[void_checklist_owner_id]
				, trg.[void_checklist_owner_entity_type]
				, isnull(trg.[void_checklist_crba8_comments],'XXXX') as void_checklist_crba8_comments
				, trg.[void_checklist_created_on]
				, trg.[void_checklist_owner_id_name]
				, isnull(trg.[void_checklist_all_compliance_issues_completed],'1900-01-01') as void_checklist_all_compliance_issues_completed
				, isnull(trg.[void_checklist_assessment_completed_and_scope_of_works_understood],'1900-01-01') as void_checklist_assessment_completed_and_scope_of_works_understood
				, isnull(trg.[void_checklist_assessment_scoping],'1900-01-01') as void_checklist_assessment_scoping
				, isnull(trg.[void_checklist_bond_recovery_forms_completed],'1900-01-01') as [void_checklist_bond_recovery_forms_completed]
				, isnull(trg.[void_checklist_bos_msd_approved_property],'1900-01-01') as [void_checklist_bos_msd_approved_property]
				, isnull(trg.[void_checklist_bos_updated_vacancy_listed],'1900-01-01') as [void_checklist_bos_updated_vacancy_listed]
				, isnull(trg.[void_checklist_bos_updated_vacate_date],'1900-01-01') as [void_checklist_bos_updated_vacate_date]
				, isnull(trg.[void_checklist_car_parking_provisioned],'1900-01-01') as [void_checklist_car_parking_provisioned]
				, isnull(trg.[void_checklist_confirm_tenancy_accepted_in_bos],'1900-01-01') as [void_checklist_confirm_tenancy_accepted_in_bos]
				, isnull(trg.[void_checklist_damage_assessment],'1900-01-01') as [void_checklist_damage_assessment]
				, isnull(trg.[void_checklist_date_bond_form_signed_given_to_agent_owner],'1900-01-01') as [void_checklist_date_bond_form_signed_given_to_agent_owner]
				, isnull(trg.[void_checklist_date_end_of_hold_for_property_redevelopment],'1900-01-01') as [void_checklist_date_end_of_hold_for_property_redevelopment]
				, isnull(trg.[void_checklist_date_finance_notified_lease_property_handed_back],'1900-01-01') as [void_checklist_date_finance_notified_lease_property_handed_back]
				, isnull(trg.[void_checklist_date_first_offer_made],'1900-01-01') as [void_checklist_date_first_offer_made]
				, isnull(trg.[void_checklist_date_hud_notified_of_tenancy_tribunal_application],'1900-01-01') as [void_checklist_date_hud_notified_of_tenancy_tribunal_application]
				, isnull(trg.[void_checklist_date_key_received_from_tenant],'1900-01-01') as [void_checklist_date_key_received_from_tenant]
				, isnull(trg.[void_checklist_date_keys_returned_from_contractor],'1900-01-01') as [void_checklist_date_keys_returned_from_contractor]
				, isnull(trg.[void_checklist_date_keys_returned_from_specialist_contractor],'1900-01-01') as [void_checklist_date_keys_returned_from_specialist_contractor]
				, isnull(trg.[void_checklist_date_keys_sent_to_specialist_contractor],'1900-01-01') as [void_checklist_date_keys_sent_to_specialist_contractor]
				, isnull(trg.[void_checklist_date_keys_surrendered_to_agent_owner],'1900-01-01') as [void_checklist_date_keys_surrendered_to_agent_owner]
				, isnull(trg.[void_checklist_date_keys_to_contractor],'1900-01-01') as [void_checklist_bos_updated_vacate_date]
				, isnull(trg.[void_checklist_date_keys_to_loss_adjuster_insurance],'1900-01-01') as [void_checklist_date_keys_to_loss_adjuster_insurance]
				, isnull(trg.[void_checklist_date_keys_to_property_team],'1900-01-01') as [void_checklist_date_keys_to_property_team]
				, isnull(trg.[void_checklist_date_keys_to_tenancy_team_to_allocate],'1900-01-01') as [void_checklist_bos_updated_vacate_date]
				, isnull(trg.[void_checklist_date_msd_notified_of_pending_termination],'1900-01-01') as [void_checklist_date_msd_notified_of_pending_termination]
				, isnull(trg.[void_checklist_date_notice_received],'1900-01-01') as [void_checklist_date_notice_received]
				, isnull(trg.[void_checklist_date_offer_confirmed_accepted],'1900-01-01') as [void_checklist_date_offer_confirmed_accepted]
				, isnull(trg.[void_checklist_date_of_final_inspection_after_keys_received],'1900-01-01') as [void_checklist_date_of_final_inspection_after_keys_received]
				, isnull(trg.[void_checklist_date_of_handover],'1900-01-01') as [void_checklist_date_of_handover]
				, isnull(trg.[void_checklist_date_possession_granted],'1900-01-01') as [void_checklist_date_possession_granted]
				, isnull(trg.[void_checklist_date_post_work_inspection_completed],'1900-01-01') as [void_checklist_date_post_work_inspection_completed]
				, isnull(trg.[void_checklist_date_pre_vacate_inspection],'1900-01-01') as [void_checklist_date_pre_vacate_inspection]
				, isnull(trg.[void_checklist_date_second_offer_made],'1900-01-01') as [void_checklist_date_second_offer_made]
				, isnull(trg.[void_checklist_date_tam_gained_access_abandoned_property],'1900-01-01') as [void_checklist_date_tam_gained_access_abandoned_property]
				, isnull(trg.[void_checklist_date_tenancy_terminated],'1900-01-01') as [void_checklist_date_tenancy_terminated]
				, isnull(trg.[void_checklist_date_work_scope_completed],'1900-01-01') as [void_checklist_date_work_scope_completed]
				, trg.[void_checklist_name]
				, isnull(trg.[void_checklist_offered_property_name],'XXXX')
				, isnull(trg.[void_checklist_property_name],'XXXX')
				, isnull(trg.[void_checklist_property_to_be_redeveloped],'1900-01-01')
				, isnull(trg.[void_checklist_property_units_submitted_to_bos_approved],'1900-01-01')
				, isnull(trg.[void_checklist_refurbishment_completed],'1900-01-01')
				, isnull(trg.[void_checklist_repairs_completed],'1900-01-01')
				, isnull(trg.[void_checklist_residential_tenancy_agreement_prepared],'1900-01-01')
				, isnull(trg.[void_checklist_rubbish_and_equipment_removed],'1900-01-01')
				, isnull(trg.[void_checklist_safety_check],'1900-01-01')
				, isnull(trg.[void_checklist_safety_check_completed],'1900-01-01')
				, isnull(trg.[void_checklist_service_name_has_been_entered_at_property],'1900-01-01')
				, isnull(trg.[void_checklist_shortlist_created],'1900-01-01')
				, isnull(trg.[void_checklist_signed_lease_or_agreement_received],'1900-01-01')
				, isnull(trg.[void_checklist_subprogram_program_entered_at_property],'1900-01-01')
				, isnull(trg.[void_checklist_target_completion_date_vacant],'1900-01-01')
				, isnull(trg.[void_checklist_target_completion_date_void],'1900-01-01')
				, isnull(trg.[void_checklist_tenancy_resolved_and_exited],'1900-01-01')
				, isnull(trg.[void_checklist_tenant_improvements_scoped_and_agreed],'1900-01-01')
				, isnull(trg.[void_checklist_upcoming_maintenance_jobs_booked],'1900-01-01')
				, isnull(trg.[void_checklist_utilities_connections_recorded_and_setup_if_applicable],'1900-01-01')
				, isnull(trg.[void_checklist_utilities_disconnected],'1900-01-01')
				, isnull(trg.[void_checklist_vacated_tenancy_name],'XXXX')
				, trg.[void_checklist_void_category_name]
				, trg.[void_checklist_void_checklist_id]
				, isnull(trg.[void_checklist_void_completed_date],'1900-01-01')
				, isnull(trg.[void_checklist_water_meter_readings_and_numbers],'1900-01-01')
				, trg.[void_checklist_is_delete_flag]
				,'X'
			
			) then  update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Soft delete missing records
			when not matched by source and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo and trg.[DWHDMLOperation] <> 'D' then update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Insert new records
			when not matched by target then 
				insert 
					([dim_property_key]
					,[dim_property_tenancy_key]
					,[dim_offered_property_key]
					,[dim_void_category_key] 
					,[void_checklist_id] 
					,[void_checklist_status] 
					,[void_checklist_status_name]
					,[void_checklist_offered_property_id] 
					,[void_checklist_offered_property_entity_type] 
					,[void_checklist_property_id] 
					,[void_checklist_property_entity_type] 
					,[void_checklist_vacated_tenancy_id] 
					,[void_checklist_vacated_tenancy_entity_type] 
					,[void_checklist_void_category_id] 
					,[void_checklist_void_category_entity_type] 
					,[void_checklist_owner_id] 
					,[void_checklist_owner_entity_type] 
					,[void_checklist_crba8_comments]
					,[void_checklist_created_on]
					,[void_checklist_owner_id_name] 
					,[void_checklist_all_compliance_issues_completed] 
					,[void_checklist_assessment_completed_and_scope_of_works_understood] 
					,[void_checklist_assessment_scoping] 
					,[void_checklist_bond_recovery_forms_completed] 
					,[void_checklist_bos_msd_approved_property] 
					,[void_checklist_bos_updated_vacancy_listed] 
					,[void_checklist_bos_updated_vacate_date] 
					,[void_checklist_car_parking_provisioned] 
					,[void_checklist_confirm_tenancy_accepted_in_bos] 
					,[void_checklist_damage_assessment] 
					,[void_checklist_date_bond_form_signed_given_to_agent_owner] 
					,[void_checklist_date_end_of_hold_for_property_redevelopment] 
					,[void_checklist_date_finance_notified_lease_property_handed_back] 
					,[void_checklist_date_first_offer_made] 
					,[void_checklist_date_hud_notified_of_tenancy_tribunal_application] 
					,[void_checklist_date_key_received_from_tenant] 
					,[void_checklist_date_keys_returned_from_contractor] 
					,[void_checklist_date_keys_returned_from_specialist_contractor] 
					,[void_checklist_date_keys_sent_to_specialist_contractor] 
					,[void_checklist_date_keys_surrendered_to_agent_owner] 
					,[void_checklist_date_keys_to_contractor] 
					,[void_checklist_date_keys_to_loss_adjuster_insurance] 
					,[void_checklist_date_keys_to_property_team] 
					,[void_checklist_date_keys_to_tenancy_team_to_allocate] 
					,[void_checklist_date_msd_notified_of_pending_termination] 
					,[void_checklist_date_notice_received] 
					,[void_checklist_date_offer_confirmed_accepted] 
					,[void_checklist_date_of_final_inspection_after_keys_received] 
					,[void_checklist_date_of_handover] 
					,[void_checklist_date_possession_granted] 
					,[void_checklist_date_post_work_inspection_completed] 
					,[void_checklist_date_pre_vacate_inspection] 
					,[void_checklist_date_second_offer_made] 
					,[void_checklist_date_tam_gained_access_abandoned_property] 
					,[void_checklist_date_tenancy_terminated] 
					,[void_checklist_date_work_scope_completed] 
					,[void_checklist_name] 
					,[void_checklist_offered_property_name] 
					,[void_checklist_property_name] 
					,[void_checklist_property_to_be_redeveloped] 
					,[void_checklist_property_units_submitted_to_bos_approved] 
					,[void_checklist_refurbishment_completed] 
					,[void_checklist_repairs_completed] 
					,[void_checklist_residential_tenancy_agreement_prepared] 
					,[void_checklist_rubbish_and_equipment_removed] 
					,[void_checklist_safety_check] 
					,[void_checklist_safety_check_completed] 
					,[void_checklist_service_name_has_been_entered_at_property] 
					,[void_checklist_shortlist_created] 
					,[void_checklist_signed_lease_or_agreement_received] 
					,[void_checklist_subprogram_program_entered_at_property] 
					,[void_checklist_target_completion_date_vacant] 
					,[void_checklist_target_completion_date_void] 
					,[void_checklist_tenancy_resolved_and_exited] 
					,[void_checklist_tenant_improvements_scoped_and_agreed] 
					,[void_checklist_upcoming_maintenance_jobs_booked] 
					,[void_checklist_utilities_connections_recorded_and_setup_if_applicable] 
					,[void_checklist_utilities_disconnected] 
					,[void_checklist_vacated_tenancy_name] 
					,[void_checklist_void_category_name] 
					,[void_checklist_void_checklist_id] 
					,[void_checklist_void_completed_date] 
					,[void_checklist_water_meter_readings_and_numbers] 
					,[void_checklist_is_delete_flag] 
					,[DWHBatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperation] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 
				)
				values
				(    src.[dim_property_key]
					,src.[dim_property_tenancy_key]
					,src.[dim_offered_property_key]
					,src.[dim_void_category_key] 
					,src.[void_checklist_id] 
					,src.[void_checklist_status]
					,src.[void_checklist_status_name]
					,src.[void_checklist_offered_property_id] 
					,src.[void_checklist_offered_property_entity_type] 
					,src.[void_checklist_property_id] 
					,src.[void_checklist_property_entity_type] 
					,src.[void_checklist_vacated_tenancy_id] 
					,src.[void_checklist_vacated_tenancy_entity_type] 
					,src.[void_checklist_void_category_id] 
					,src.[void_checklist_void_category_entity_type] 
					,src.[void_checklist_owner_id] 
					,src.[void_checklist_owner_entity_type] 
					,src.[void_checklist_crba8_comments]
					,src.[void_checklist_created_on]
					,src.[void_checklist_owner_id_name] 
					,src.[void_checklist_all_compliance_issues_completed] 
					,src.[void_checklist_assessment_completed_and_scope_of_works_understood] 
					,src.[void_checklist_assessment_scoping] 
					,src.[void_checklist_bond_recovery_forms_completed] 
					,src.[void_checklist_bos_msd_approved_property] 
					,src.[void_checklist_bos_updated_vacancy_listed] 
					,src.[void_checklist_bos_updated_vacate_date] 
					,src.[void_checklist_car_parking_provisioned] 
					,src.[void_checklist_confirm_tenancy_accepted_in_bos] 
					,src.[void_checklist_damage_assessment] 
					,src.[void_checklist_date_bond_form_signed_given_to_agent_owner] 
					,src.[void_checklist_date_end_of_hold_for_property_redevelopment] 
					,src.[void_checklist_date_finance_notified_lease_property_handed_back] 
					,src.[void_checklist_date_first_offer_made] 
					,src.[void_checklist_date_hud_notified_of_tenancy_tribunal_application] 
					,src.[void_checklist_date_key_received_from_tenant] 
					,src.[void_checklist_date_keys_returned_from_contractor] 
					,src.[void_checklist_date_keys_returned_from_specialist_contractor] 
					,src.[void_checklist_date_keys_sent_to_specialist_contractor] 
					,src.[void_checklist_date_keys_surrendered_to_agent_owner] 
					,src.[void_checklist_date_keys_to_contractor] 
					,src.[void_checklist_date_keys_to_loss_adjuster_insurance] 
					,src.[void_checklist_date_keys_to_property_team] 
					,src.[void_checklist_date_keys_to_tenancy_team_to_allocate] 
					,src.[void_checklist_date_msd_notified_of_pending_termination] 
					,src.[void_checklist_date_notice_received] 
					,src.[void_checklist_date_offer_confirmed_accepted] 
					,src.[void_checklist_date_of_final_inspection_after_keys_received] 
					,src.[void_checklist_date_of_handover] 
					,src.[void_checklist_date_possession_granted] 
					,src.[void_checklist_date_post_work_inspection_completed] 
					,src.[void_checklist_date_pre_vacate_inspection] 
					,src.[void_checklist_date_second_offer_made] 
					,src.[void_checklist_date_tam_gained_access_abandoned_property] 
					,src.[void_checklist_date_tenancy_terminated] 
					,src.[void_checklist_date_work_scope_completed] 
					,src.[void_checklist_name] 
					,src.[void_checklist_offered_property_name] 
					,src.[void_checklist_property_name] 
					,src.[void_checklist_property_to_be_redeveloped] 
					,src.[void_checklist_property_units_submitted_to_bos_approved] 
					,src.[void_checklist_refurbishment_completed] 
					,src.[void_checklist_repairs_completed] 
					,src.[void_checklist_residential_tenancy_agreement_prepared] 
					,src.[void_checklist_rubbish_and_equipment_removed] 
					,src.[void_checklist_safety_check] 
					,src.[void_checklist_safety_check_completed] 
					,src.[void_checklist_service_name_has_been_entered_at_property] 
					,src.[void_checklist_shortlist_created] 
					,src.[void_checklist_signed_lease_or_agreement_received] 
					,src.[void_checklist_subprogram_program_entered_at_property] 
					,src.[void_checklist_target_completion_date_vacant] 
					,src.[void_checklist_target_completion_date_void] 
					,src.[void_checklist_tenancy_resolved_and_exited] 
					,src.[void_checklist_tenant_improvements_scoped_and_agreed] 
					,src.[void_checklist_upcoming_maintenance_jobs_booked] 
					,src.[void_checklist_utilities_connections_recorded_and_setup_if_applicable] 
					,src.[void_checklist_utilities_disconnected] 
					,src.[void_checklist_vacated_tenancy_name] 
					,src.[void_checklist_void_category_name] 
					,src.[void_checklist_void_checklist_id] 
					,src.[void_checklist_void_completed_date] 
					,src.[void_checklist_water_meter_readings_and_numbers] 
					,src.[void_checklist_is_delete_flag] 
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[void_checklist_id],inserted.[void_checklist_id]), coalesce(src.[void_checklist_offered_property_id],inserted.[void_checklist_offered_property_id]), coalesce(src.[void_checklist_property_id],inserted.[void_checklist_property_id]), coalesce(src.[void_checklist_vacated_tenancy_id],inserted.[void_checklist_vacated_tenancy_id]), coalesce(src.[void_checklist_void_category_id],inserted.[void_checklist_void_category_id]), $action As [MergeAction] into #SummaryOfChanges;

			-- Insert new versions of previously updated records (Updates and Deletes)
			insert into [edw].[fact_void_checklist]
			(    [dim_property_key]
				,[dim_property_tenancy_key]
				,[dim_offered_property_key]
				,[dim_void_category_key] 
				,[void_checklist_id] 
				,[void_checklist_status] 
				,[void_checklist_status_name]
				,[void_checklist_offered_property_id] 
				,[void_checklist_offered_property_entity_type] 
				,[void_checklist_property_id] 
				,[void_checklist_property_entity_type] 
				,[void_checklist_vacated_tenancy_id] 
				,[void_checklist_vacated_tenancy_entity_type] 
				,[void_checklist_void_category_id] 
				,[void_checklist_void_category_entity_type] 
				,[void_checklist_owner_id] 
				,[void_checklist_owner_entity_type] 
				,[void_checklist_crba8_comments] 
				,[void_checklist_created_on]
				,[void_checklist_owner_id_name] 
				,[void_checklist_all_compliance_issues_completed] 
				,[void_checklist_assessment_completed_and_scope_of_works_understood] 
				,[void_checklist_assessment_scoping] 
				,[void_checklist_bond_recovery_forms_completed] 
				,[void_checklist_bos_msd_approved_property] 
				,[void_checklist_bos_updated_vacancy_listed] 
				,[void_checklist_bos_updated_vacate_date] 
				,[void_checklist_car_parking_provisioned] 
				,[void_checklist_confirm_tenancy_accepted_in_bos] 
				,[void_checklist_damage_assessment] 
				,[void_checklist_date_bond_form_signed_given_to_agent_owner] 
				,[void_checklist_date_end_of_hold_for_property_redevelopment] 
				,[void_checklist_date_finance_notified_lease_property_handed_back] 
				,[void_checklist_date_first_offer_made] 
				,[void_checklist_date_hud_notified_of_tenancy_tribunal_application] 
				,[void_checklist_date_key_received_from_tenant] 
				,[void_checklist_date_keys_returned_from_contractor] 
				,[void_checklist_date_keys_returned_from_specialist_contractor] 
				,[void_checklist_date_keys_sent_to_specialist_contractor] 
				,[void_checklist_date_keys_surrendered_to_agent_owner] 
				,[void_checklist_date_keys_to_contractor] 
				,[void_checklist_date_keys_to_loss_adjuster_insurance] 
				,[void_checklist_date_keys_to_property_team] 
				,[void_checklist_date_keys_to_tenancy_team_to_allocate] 
				,[void_checklist_date_msd_notified_of_pending_termination] 
				,[void_checklist_date_notice_received] 
				,[void_checklist_date_offer_confirmed_accepted] 
				,[void_checklist_date_of_final_inspection_after_keys_received] 
				,[void_checklist_date_of_handover] 
				,[void_checklist_date_possession_granted] 
				,[void_checklist_date_post_work_inspection_completed] 
				,[void_checklist_date_pre_vacate_inspection] 
				,[void_checklist_date_second_offer_made] 
				,[void_checklist_date_tam_gained_access_abandoned_property] 
				,[void_checklist_date_tenancy_terminated] 
				,[void_checklist_date_work_scope_completed] 
				,[void_checklist_name] 
				,[void_checklist_offered_property_name] 
				,[void_checklist_property_name] 
				,[void_checklist_property_to_be_redeveloped] 
				,[void_checklist_property_units_submitted_to_bos_approved] 
				,[void_checklist_refurbishment_completed] 
				,[void_checklist_repairs_completed] 
				,[void_checklist_residential_tenancy_agreement_prepared] 
				,[void_checklist_rubbish_and_equipment_removed] 
				,[void_checklist_safety_check] 
				,[void_checklist_safety_check_completed] 
				,[void_checklist_service_name_has_been_entered_at_property] 
				,[void_checklist_shortlist_created] 
				,[void_checklist_signed_lease_or_agreement_received] 
				,[void_checklist_subprogram_program_entered_at_property] 
				,[void_checklist_target_completion_date_vacant] 
				,[void_checklist_target_completion_date_void] 
				,[void_checklist_tenancy_resolved_and_exited] 
				,[void_checklist_tenant_improvements_scoped_and_agreed] 
				,[void_checklist_upcoming_maintenance_jobs_booked] 
				,[void_checklist_utilities_connections_recorded_and_setup_if_applicable] 
				,[void_checklist_utilities_disconnected] 
				,[void_checklist_vacated_tenancy_name] 
				,[void_checklist_void_category_name] 
				,[void_checklist_void_checklist_id] 
				,[void_checklist_void_completed_date] 
				,[void_checklist_water_meter_readings_and_numbers] 
				,[void_checklist_is_delete_flag] 
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
			)
			select
				 src.[dim_property_key]
				,src.[dim_property_tenancy_key]
				,src.[dim_offered_property_key]
				,src.[dim_void_category_key] 
				,src.[void_checklist_id] 
				,src.[void_checklist_status]
				,src.[void_checklist_status_name]
				,src.[void_checklist_offered_property_id] 
				,src.[void_checklist_offered_property_entity_type] 
				,src.[void_checklist_property_id] 
				,src.[void_checklist_property_entity_type] 
				,src.[void_checklist_vacated_tenancy_id] 
				,src.[void_checklist_vacated_tenancy_entity_type] 
				,src.[void_checklist_void_category_id] 
				,src.[void_checklist_void_category_entity_type] 
				,src.[void_checklist_owner_id] 
				,src.[void_checklist_owner_entity_type] 
				,src.[void_checklist_crba8_comments]
				,src.[void_checklist_created_on]
				,src.[void_checklist_owner_id_name] 
				,src.[void_checklist_all_compliance_issues_completed] 
				,src.[void_checklist_assessment_completed_and_scope_of_works_understood] 
				,src.[void_checklist_assessment_scoping] 
				,src.[void_checklist_bond_recovery_forms_completed] 
				,src.[void_checklist_bos_msd_approved_property] 
				,src.[void_checklist_bos_updated_vacancy_listed] 
				,src.[void_checklist_bos_updated_vacate_date] 
				,src.[void_checklist_car_parking_provisioned] 
				,src.[void_checklist_confirm_tenancy_accepted_in_bos] 
				,src.[void_checklist_damage_assessment] 
				,src.[void_checklist_date_bond_form_signed_given_to_agent_owner] 
				,src.[void_checklist_date_end_of_hold_for_property_redevelopment] 
				,src.[void_checklist_date_finance_notified_lease_property_handed_back] 
				,src.[void_checklist_date_first_offer_made] 
				,src.[void_checklist_date_hud_notified_of_tenancy_tribunal_application] 
				,src.[void_checklist_date_key_received_from_tenant] 
				,src.[void_checklist_date_keys_returned_from_contractor] 
				,src.[void_checklist_date_keys_returned_from_specialist_contractor] 
				,src.[void_checklist_date_keys_sent_to_specialist_contractor] 
				,src.[void_checklist_date_keys_surrendered_to_agent_owner] 
				,src.[void_checklist_date_keys_to_contractor] 
				,src.[void_checklist_date_keys_to_loss_adjuster_insurance] 
				,src.[void_checklist_date_keys_to_property_team] 
				,src.[void_checklist_date_keys_to_tenancy_team_to_allocate] 
				,src.[void_checklist_date_msd_notified_of_pending_termination] 
				,src.[void_checklist_date_notice_received] 
				,src.[void_checklist_date_offer_confirmed_accepted] 
				,src.[void_checklist_date_of_final_inspection_after_keys_received] 
				,src.[void_checklist_date_of_handover] 
				,src.[void_checklist_date_possession_granted] 
				,src.[void_checklist_date_post_work_inspection_completed] 
				,src.[void_checklist_date_pre_vacate_inspection] 
				,src.[void_checklist_date_second_offer_made] 
				,src.[void_checklist_date_tam_gained_access_abandoned_property] 
				,src.[void_checklist_date_tenancy_terminated] 
				,src.[void_checklist_date_work_scope_completed] 
				,src.[void_checklist_name] 
				,src.[void_checklist_offered_property_name] 
				,src.[void_checklist_property_name] 
				,src.[void_checklist_property_to_be_redeveloped] 
				,src.[void_checklist_property_units_submitted_to_bos_approved] 
				,src.[void_checklist_refurbishment_completed] 
				,src.[void_checklist_repairs_completed] 
				,src.[void_checklist_residential_tenancy_agreement_prepared] 
				,src.[void_checklist_rubbish_and_equipment_removed] 
				,src.[void_checklist_safety_check] 
				,src.[void_checklist_safety_check_completed] 
				,src.[void_checklist_service_name_has_been_entered_at_property] 
				,src.[void_checklist_shortlist_created] 
				,src.[void_checklist_signed_lease_or_agreement_received] 
				,src.[void_checklist_subprogram_program_entered_at_property] 
				,src.[void_checklist_target_completion_date_vacant] 
				,src.[void_checklist_target_completion_date_void] 
				,src.[void_checklist_tenancy_resolved_and_exited] 
				,src.[void_checklist_tenant_improvements_scoped_and_agreed] 
				,src.[void_checklist_upcoming_maintenance_jobs_booked] 
				,src.[void_checklist_utilities_connections_recorded_and_setup_if_applicable] 
				,src.[void_checklist_utilities_disconnected] 
				,src.[void_checklist_vacated_tenancy_name] 
				,src.[void_checklist_void_category_name] 
				,src.[void_checklist_void_checklist_id] 
				,src.[void_checklist_void_completed_date] 
				,src.[void_checklist_water_meter_readings_and_numbers] 
				,src.[void_checklist_is_delete_flag] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'Zavanti.vw_zav_voidchecklist'
				,'U'
			from #SummaryOfChanges as base
			inner join [Staging].[ODSETLfact_void_checklist] as src 
				--on src.[void_checklist_id] = base.[void_checklist_id] 
				--and src.[void_checklist_offered_property_id] = base.[void_checklist_offered_property_id] 
				--and src.[void_checklist_property_id] = base.[void_checklist_property_id] 
				--and src.[void_checklist_vacated_tenancy_id] = base.[void_checklist_vacated_tenancy_id] 
				--and src.[void_checklist_void_category_id] = base.[void_checklist_void_category_id]

			on src.[void_checklist_id] = base.[void_checklist_id] 
				and ISNULL(src.[void_checklist_offered_property_id], CAST(0x0 AS UNIQUEIDENTIFIER)) = ISNULL(base.[void_checklist_offered_property_id], CAST(0x0 AS UNIQUEIDENTIFIER))
				and ISNULL(src.[void_checklist_property_id], CAST(0x0 AS UNIQUEIDENTIFIER)) = ISNULL(base.[void_checklist_property_id], CAST(0x0 AS UNIQUEIDENTIFIER))
				and ISNULL(src.[void_checklist_vacated_tenancy_id], CAST(0x0 AS UNIQUEIDENTIFIER)) = ISNULL(base.[void_checklist_vacated_tenancy_id], CAST(0x0 AS UNIQUEIDENTIFIER))
				and ISNULL(src.[void_checklist_void_category_id], CAST(0x0 AS UNIQUEIDENTIFIER)) = ISNULL(base.[void_checklist_void_category_id], CAST(0x0 AS UNIQUEIDENTIFIER))



			where base.[MergeAction] = 'UPDATE'

			union all 

			select
				 tbl.[dim_property_key]
				,tbl.[dim_property_tenancy_key]
				,tbl.[dim_offered_property_key]
				,tbl.[dim_void_category_key] 
				,tbl.[void_checklist_id] 
				,tbl.[void_checklist_status] 
				,tbl.[void_checklist_status_name]
				,tbl.[void_checklist_offered_property_id] 
				,tbl.[void_checklist_offered_property_entity_type] 
				,tbl.[void_checklist_property_id] 
				,tbl.[void_checklist_property_entity_type] 
				,tbl.[void_checklist_vacated_tenancy_id] 
				,tbl.[void_checklist_vacated_tenancy_entity_type] 
				,tbl.[void_checklist_void_category_id] 
				,tbl.[void_checklist_void_category_entity_type] 
				,tbl.[void_checklist_owner_id] 
				,tbl.[void_checklist_owner_entity_type] 
				,tbl.[void_checklist_crba8_comments] 
				,tbl.[void_checklist_created_on]
				,tbl.[void_checklist_owner_id_name] 
				,tbl.[void_checklist_all_compliance_issues_completed] 
				,tbl.[void_checklist_assessment_completed_and_scope_of_works_understood] 
				,tbl.[void_checklist_assessment_scoping] 
				,tbl.[void_checklist_bond_recovery_forms_completed] 
				,tbl.[void_checklist_bos_msd_approved_property] 
				,tbl.[void_checklist_bos_updated_vacancy_listed] 
				,tbl.[void_checklist_bos_updated_vacate_date] 
				,tbl.[void_checklist_car_parking_provisioned] 
				,tbl.[void_checklist_confirm_tenancy_accepted_in_bos] 
				,tbl.[void_checklist_damage_assessment] 
				,tbl.[void_checklist_date_bond_form_signed_given_to_agent_owner] 
				,tbl.[void_checklist_date_end_of_hold_for_property_redevelopment] 
				,tbl.[void_checklist_date_finance_notified_lease_property_handed_back] 
				,tbl.[void_checklist_date_first_offer_made] 
				,tbl.[void_checklist_date_hud_notified_of_tenancy_tribunal_application] 
				,tbl.[void_checklist_date_key_received_from_tenant] 
				,tbl.[void_checklist_date_keys_returned_from_contractor] 
				,tbl.[void_checklist_date_keys_returned_from_specialist_contractor] 
				,tbl.[void_checklist_date_keys_sent_to_specialist_contractor] 
				,tbl.[void_checklist_date_keys_surrendered_to_agent_owner] 
				,tbl.[void_checklist_date_keys_to_contractor] 
				,tbl.[void_checklist_date_keys_to_loss_adjuster_insurance] 
				,tbl.[void_checklist_date_keys_to_property_team] 
				,tbl.[void_checklist_date_keys_to_tenancy_team_to_allocate] 
				,tbl.[void_checklist_date_msd_notified_of_pending_termination] 
				,tbl.[void_checklist_date_notice_received] 
				,tbl.[void_checklist_date_offer_confirmed_accepted] 
				,tbl.[void_checklist_date_of_final_inspection_after_keys_received] 
				,tbl.[void_checklist_date_of_handover] 
				,tbl.[void_checklist_date_possession_granted] 
				,tbl.[void_checklist_date_post_work_inspection_completed] 
				,tbl.[void_checklist_date_pre_vacate_inspection] 
				,tbl.[void_checklist_date_second_offer_made] 
				,tbl.[void_checklist_date_tam_gained_access_abandoned_property] 
				,tbl.[void_checklist_date_tenancy_terminated] 
				,tbl.[void_checklist_date_work_scope_completed] 
				,tbl.[void_checklist_name] 
				,tbl.[void_checklist_offered_property_name] 
				,tbl.[void_checklist_property_name] 
				,tbl.[void_checklist_property_to_be_redeveloped] 
				,tbl.[void_checklist_property_units_submitted_to_bos_approved] 
				,tbl.[void_checklist_refurbishment_completed] 
				,tbl.[void_checklist_repairs_completed] 
				,tbl.[void_checklist_residential_tenancy_agreement_prepared] 
				,tbl.[void_checklist_rubbish_and_equipment_removed] 
				,tbl.[void_checklist_safety_check] 
				,tbl.[void_checklist_safety_check_completed] 
				,tbl.[void_checklist_service_name_has_been_entered_at_property] 
				,tbl.[void_checklist_shortlist_created] 
				,tbl.[void_checklist_signed_lease_or_agreement_received] 
				,tbl.[void_checklist_subprogram_program_entered_at_property] 
				,tbl.[void_checklist_target_completion_date_vacant] 
				,tbl.[void_checklist_target_completion_date_void] 
				,tbl.[void_checklist_tenancy_resolved_and_exited] 
				,tbl.[void_checklist_tenant_improvements_scoped_and_agreed] 
				,tbl.[void_checklist_upcoming_maintenance_jobs_booked] 
				,tbl.[void_checklist_utilities_connections_recorded_and_setup_if_applicable] 
				,tbl.[void_checklist_utilities_disconnected] 
				,tbl.[void_checklist_vacated_tenancy_name] 
				,tbl.[void_checklist_void_category_name] 
				,tbl.[void_checklist_void_checklist_id] 
				,tbl.[void_checklist_void_completed_date] 
				,tbl.[void_checklist_water_meter_readings_and_numbers] 
				,tbl.[void_checklist_is_delete_flag] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'Zavanti.vw_zav_voidchecklist'
				,'D'
			from #SummaryOfChanges as base
			inner join [edw].[fact_void_checklist] as tbl 
				on tbl.[void_checklist_id] = base.[void_checklist_id] 
				--and tbl.[void_checklist_offered_property_id] = base.[void_checklist_offered_property_id] 
				--and tbl.[void_checklist_property_id] = base.[void_checklist_property_id] 
				--and tbl.[void_checklist_vacated_tenancy_id] = base.[void_checklist_vacated_tenancy_id] 
				--and tbl.[void_checklist_void_category_id] = base.[void_checklist_void_category_id] 
				and ISNULL(tbl.[void_checklist_offered_property_id], CAST(0x0 AS UNIQUEIDENTIFIER)) = ISNULL(base.[void_checklist_offered_property_id], CAST(0x0 AS UNIQUEIDENTIFIER))
				and ISNULL(tbl.[void_checklist_property_id], CAST(0x0 AS UNIQUEIDENTIFIER)) = ISNULL(base.[void_checklist_property_id], CAST(0x0 AS UNIQUEIDENTIFIER))
				and ISNULL(tbl.[void_checklist_vacated_tenancy_id], CAST(0x0 AS UNIQUEIDENTIFIER)) = ISNULL(base.[void_checklist_vacated_tenancy_id], CAST(0x0 AS UNIQUEIDENTIFIER))
				and ISNULL(tbl.[void_checklist_void_category_id], CAST(0x0 AS UNIQUEIDENTIFIER)) = ISNULL(base.[void_checklist_void_category_id], CAST(0x0 AS UNIQUEIDENTIFIER))
				and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			
			left join [Staging].[ODSETLfact_void_checklist] as src 
				on src.[void_checklist_id] = base.[void_checklist_id] 
				--and src.[void_checklist_offered_property_id] = base.[void_checklist_offered_property_id] 
				--and src.[void_checklist_property_id] = base.[void_checklist_property_id] 
				--and src.[void_checklist_vacated_tenancy_id] = base.[void_checklist_vacated_tenancy_id] 
				--and src.[void_checklist_void_category_id] = base.[void_checklist_void_category_id]
				
				and ISNULL(src.[void_checklist_offered_property_id], CAST(0x0 AS UNIQUEIDENTIFIER)) = ISNULL(base.[void_checklist_offered_property_id], CAST(0x0 AS UNIQUEIDENTIFIER))
				and ISNULL(src.[void_checklist_property_id], CAST(0x0 AS UNIQUEIDENTIFIER)) = ISNULL(base.[void_checklist_property_id], CAST(0x0 AS UNIQUEIDENTIFIER))
				and ISNULL(src.[void_checklist_vacated_tenancy_id], CAST(0x0 AS UNIQUEIDENTIFIER)) = ISNULL(base.[void_checklist_vacated_tenancy_id], CAST(0x0 AS UNIQUEIDENTIFIER))
				and ISNULL(src.[void_checklist_void_category_id], CAST(0x0 AS UNIQUEIDENTIFIER)) = ISNULL(base.[void_checklist_void_category_id], CAST(0x0 AS UNIQUEIDENTIFIER))


			
			where base.[MergeAction] = 'UPDATE'
			and src.[void_checklist_id] is null 
			and src.[void_checklist_offered_property_id] is null 
			and src.[void_checklist_property_id] is null 
			and src.[void_checklist_vacated_tenancy_id] is null 
			and src.[void_checklist_void_category_id] is null;
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[fact_void_checklist]
		where [DWHEffectiveTo] = @SystemDefaultEffectiveTo;

		commit transaction;
	end try
	begin catch
		rollback transaction;

		set @pErrorRecords = @stagedRecords - @insertedRecords - @updatedRecords - @deletedRecords;
		set @pInsertRecords = @insertedRecords;
		set @pUpdateRecords = @updatedRecords;
		set @pDeleteRecords = @deletedRecords;
		set @pCompleted = 0;
		set @pTargetRecords = @targetRecords;
		set @pErrorMessage = ERROR_MESSAGE();

		if (@pOutputParamsAsDataset = 1)
		begin
			-- Select return parameters as a dataset
			select @pErrorRecords	as ErrorRecords,
					@pInsertRecords as InsertRecords,
					@pUpdateRecords as UpdateRecords,
					@pDeleteRecords as DeleteRecords,
					@pCompleted		as Completed,
					@targetRecords	as TargetRecords,
					@pErrorMessage as ErrorMessage;
		end;
		throw;
	end catch

	set @pErrorRecords = @stagedRecords - @insertedRecords - @updatedRecords - @deletedRecords;
	set @pInsertRecords = @insertedRecords;
	set @pUpdateRecords = @updatedRecords;
	set @pDeleteRecords = @deletedRecords;
	set @pCompleted = 1;
	set @pTargetRecords = @targetRecords;

	if (@pOutputParamsAsDataset = 1)
	begin
		-- Select return parameters as a dataset
		select @pErrorRecords	as ErrorRecords,
				@pInsertRecords as InsertRecords,
				@pUpdateRecords as UpdateRecords,
				@pDeleteRecords as DeleteRecords,
				@pCompleted		as Completed,
				@targetRecords	as TargetRecords,
				@pErrorMessage as ErrorMessage;
	end;
end;