
CREATE PROC [staging].[insert_staging_fact_void_checklist]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_void_checklist]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-03-10    Greg Nuthall		Initial version
1.1      2025-04-30    Greg Nuthall		Added create  and status name
1.2      2026-06-05    Greg Nuthall		Added an additional way to lookup offered property from the name 
										and set nulls and '0000' to 0 dim_key
****************************************************************************/

	IF OBJECT_ID('tempdb..#dim_property_ranked') IS NOT NULL DROP TABLE #dim_property_ranked;
	IF OBJECT_ID('tempdb..#offered_property_lookup') IS NOT NULL DROP TABLE #offered_property_lookup;


SELECT
	property_name,
	dim_property_key,
	property_id,
	ROW_NUMBER() OVER (PARTITION BY property_name ORDER BY dim_property_key DESC, property_id DESC) AS rn
	into #dim_property_ranked
	FROM edw.dim_property
	WHERE DWHIsCurrent = 1


SELECT distinct
		vc.offered_property_id,
		vc.offered_property_name,
		p2.dim_property_key,
		p2.property_id,
		x.property_lookup
		into #offered_property_lookup
		
		FROM landing.edw_fact_property_void_checklist vc
		CROSS APPLY (
			SELECT
				first_dash  = CHARINDEX('-', vc.offered_property_name),
				second_dash = CASE
								WHEN CHARINDEX('-', vc.offered_property_name) > 0
									THEN CHARINDEX('-', vc.offered_property_name, CHARINDEX('-', vc.offered_property_name) + 1)
								ELSE 0
							  END
		) d
		CROSS APPLY (
			SELECT
				property_lookup = CASE
									WHEN d.second_dash > 1 THEN TRIM(LEFT(vc.offered_property_name, d.second_dash - 1))
									WHEN d.first_dash  > 1 THEN TRIM(LEFT(vc.offered_property_name, d.first_dash - 1))
									ELSE vc.offered_property_name
								  END
		) x
		LEFT OUTER JOIN (select * from #dim_property_ranked where rn = 1) p2
			ON x.property_lookup = p2.property_name


--  clear the staging table before loading
	truncate table [Staging].[ODSETLfact_void_checklist]

-- insert data from landing table into staging table
	insert into [Staging].[ODSETLfact_void_checklist] (
			[void_checklist_id] 
			,[void_checklist_property_id] 
			,[dim_property_key]
			,[void_checklist_vacated_tenancy_id] 
			,[dim_property_tenancy_key]
			,[void_checklist_offered_property_id]
			,[dim_offered_property_key]
			,[void_checklist_void_category_id] 
			,[dim_void_category_key]
			,[void_checklist_offered_property_entity_type] 
			,[void_checklist_status] 
			,[void_checklist_status_name]
			,[void_checklist_property_entity_type] 
			,[void_checklist_vacated_tenancy_entity_type] 
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
		)
	
	select
		 vc.[void_checklist_id] 
		,vc.[void_checklist_property_id] 
		,p.[dim_property_key]
		,vc.[void_checklist_vacated_tenancy_id] 
		,pt.[dim_property_tenancy_key]
		,vc.[void_checklist_offered_property_id]
		,case when vc.void_checklist_offered_property_id is null 
				or vc.void_checklist_offered_property_id = '00000000-0000-0000-0000-000000000000'
				then 0 
			else 
				isnull(isnull(op.[dim_property_key],olk.dim_property_key),-1) 
			end as [dim_offered_property_key]
		,vc.[void_checklist_void_category_id] 
		,v.[dim_void_category_key]
		,vc.[void_checklist_offered_property_entity_type] 
		,vc.[void_checklist_status]
		,vc.[void_checklist_status_name]
		,vc.[void_checklist_property_entity_type] 
		,vc.[void_checklist_vacated_tenancy_entity_type] 
		,vc.[void_checklist_void_category_entity_type] 
		,vc.[void_checklist_owner_id] 
		,vc.[void_checklist_owner_entity_type] 
		,vc.[void_checklist_crba8_comments]
		,vc.[void_checklist_created_on]
		,vc.[void_checklist_owner_id_name] 
		,vc.[void_checklist_all_compliance_issues_completed] 
		,vc.[void_checklist_assessment_completed_and_scope_of_works_understood] 
		,vc.[void_checklist_assessment_scoping] 
		,vc.[void_checklist_bond_recovery_forms_completed] 
		,vc.[void_checklist_bos_msd_approved_property] 
		,vc.[void_checklist_bos_updated_vacancy_listed] 
		,vc.[void_checklist_bos_updated_vacate_date] 
		,vc.[void_checklist_car_parking_provisioned] 
		,vc.[void_checklist_confirm_tenancy_accepted_in_bos] 
		,vc.[void_checklist_damage_assessment] 
		,vc.[void_checklist_date_bond_form_signed_given_to_agent_owner] 
		,vc.[void_checklist_date_end_of_hold_for_property_redevelopment] 
		,vc.[void_checklist_date_finance_notified_lease_property_handed_back] 
		,vc.[void_checklist_date_first_offer_made] 
		,vc.[void_checklist_date_hud_notified_of_tenancy_tribunal_application] 
		,vc.[void_checklist_date_key_received_from_tenant] 
		,vc.[void_checklist_date_keys_returned_from_contractor] 
		,vc.[void_checklist_date_keys_returned_from_specialist_contractor] 
		,vc.[void_checklist_date_keys_sent_to_specialist_contractor] 
		,vc.[void_checklist_date_keys_surrendered_to_agent_owner] 
		,vc.[void_checklist_date_keys_to_contractor] 
		,vc.[void_checklist_date_keys_to_loss_adjuster_insurance] 
		,vc.[void_checklist_date_keys_to_property_team] 
		,vc.[void_checklist_date_keys_to_tenancy_team_to_allocate] 
		,vc.[void_checklist_date_msd_notified_of_pending_termination] 
		,vc.[void_checklist_date_notice_received] 
		,vc.[void_checklist_date_offer_confirmed_accepted] 
		,vc.[void_checklist_date_of_final_inspection_after_keys_received] 
		,vc.[void_checklist_date_of_handover] 
		,vc.[void_checklist_date_possession_granted] 
		,vc.[void_checklist_date_post_work_inspection_completed] 
		,vc.[void_checklist_date_pre_vacate_inspection] 
		,vc.[void_checklist_date_second_offer_made] 
		,vc.[void_checklist_date_tam_gained_access_abandoned_property] 
		,vc.[void_checklist_date_tenancy_terminated] 
		,vc.[void_checklist_date_work_scope_completed] 
		,vc.[void_checklist_name] 
		,vc.[void_checklist_offered_property_name] 
		,vc.[void_checklist_property_name] 
		,vc.[void_checklist_property_to_be_redeveloped] 
		,vc.[void_checklist_property_units_submitted_to_bos_approved] 
		,vc.[void_checklist_refurbishment_completed] 
		,vc.[void_checklist_repairs_completed] 
		,vc.[void_checklist_residential_tenancy_agreement_prepared] 
		,vc.[void_checklist_rubbish_and_equipment_removed] 
		,vc.[void_checklist_safety_check] 
		,vc.[void_checklist_safety_check_completed] 
		,vc.[void_checklist_service_name_has_been_entered_at_property] 
		,vc.[void_checklist_shortlist_created] 
		,vc.[void_checklist_signed_lease_or_agreement_received] 
		,vc.[void_checklist_subprogram_program_entered_at_property] 
		,vc.[void_checklist_target_completion_date_vacant] 
		,vc.[void_checklist_target_completion_date_void] 
		,vc.[void_checklist_tenancy_resolved_and_exited] 
		,vc.[void_checklist_tenant_improvements_scoped_and_agreed] 
		,vc.[void_checklist_upcoming_maintenance_jobs_booked] 
		,vc.[void_checklist_utilities_connections_recorded_and_setup_if_applicable] 
		,vc.[void_checklist_utilities_disconnected] 
		,vc.[void_checklist_vacated_tenancy_name] 
		,vc.[void_checklist_void_category_name] 
		,vc.[void_checklist_void_checklist_id] 
		,vc.[void_checklist_void_completed_date] 
		,vc.[void_checklist_water_meter_readings_and_numbers] 
		,vc.[void_checklist_is_delete_flag] 

	from [Landing].[edw_fact_void_checklist] vc
	left outer join edw.dim_property p on vc.[void_checklist_property_id] = p.property_id and p.DWHIsCurrent = 1
	left outer join edw.dim_property op on vc.[void_checklist_offered_property_id] = op.property_id and op.DWHIsCurrent = 1
	left outer join #offered_property_lookup olk 
		on vc.void_checklist_offered_property_id = olk.offered_property_id
		and vc.void_checklist_offered_property_name = olk.offered_property_name
	left outer join edw.dim_property_tenancy pt on vc.[void_checklist_vacated_tenancy_id] = pt.property_tenancy_id and pt.DWHIsCurrent = 1
	left outer join edw.dim_void_category v on vc.[void_checklist_void_category_id] = v.void_category_id and v.DWHIsCurrent = 1