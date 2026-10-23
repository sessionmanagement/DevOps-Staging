
CREATE procedure [edw].[Updateedwdim_property_tenancy]

 /**********************************************************************************************************
 Procedure	[edw].[Updateedwdim_property_tenancy]
 Author		Glenn McLeod
 Created	27/06/2024	
 Purpose	Full the property_tenancy dimension table	 				
 Notes:     Call By	EDW Pipeline '30_Load_From_ODS'
 =========================================================================================================

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		27/06/2024	   Glenn McLeod			Initial creation of stored procedure
1.1		03/02/2025	   Greg Nuthall			Added vacated_date
1.2		12/02/2025	   Greg Nuthall			Added property_tenant_opportunity_status
1.3		10/03/2025	   Greg Nuthall		    Added property_id and dim_property_key
1.4		27/08/2025	   Greg Nuthall		    Added property_tenancy_primary_tenant_recordbaseid for Bug #11084
2.0		20/02/2026	   Greg Nuthall			Removed 92 columns not in table DDL for User Story #12210
2.1     2026-07-27     Greg Nuthall         Added property_tenancy_primary_tenant_gender, primary_contact_ethnicity_name (User Story 14211)
**********************************************************************************************************/

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
    declare @SourceSystem nvarchar(120) = '[Staging].[ODSETLdim_property_tenancy]';

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
    if( object_id( 'tempdb..#SummaryOfChanges') is not null ) drop table #SummaryOfChanges;
    create table #SummaryOfChanges
    (
        [property_tenancy_id] uniqueidentifier null
		,[MergeAction] varchar(10)
    );
    begin transaction;
    begin try
		
		-- Do not run if there are no records in source
		select @stagedRecords = count(1)
    from [Staging].[ODSETLdim_property_tenancy];
		if( @stagedRecords = 0 )
		begin
        select
            @targetRecords = count(1) 
				, @deletedRecords = sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
        from [edw].[dim_property_tenancy];
        -- Select success details
        select
            @pErrorRecords = 0
				, @pInsertRecords = 0
				, @pUpdateRecords = 0
				, @pDeleteRecords = 0
				, @pCompleted = 1
				, @pTargetRecords = @targetRecords;

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

        commit transaction;
        return;
    end;



		 -- Insert Default records if table is empty

		IF (
		NOT EXISTS (
			SELECT 1
    FROM [edw].[dim_property_tenancy]
    WHERE [dim_property_tenancy_key] <= 0
			)
		)
		BEGIN

        --turn the identity insert on 
        SET IDENTITY_INSERT [edw].[dim_property_tenancy] ON

        INSERT INTO [edw].[dim_property_tenancy]
            (
            [dim_property_tenancy_key]
            ,[dim_property_key]
			,[dim_gender_key] 
            ,[property_tenancy_tenancy_type]
            ,[property_tenancy_owning_business_unit_name]
            ,[property_tenancy_tenancy_identifier]
            ,[property_tenancy_tenancy_reference]
            ,[property_tenancy_tenancy_name]
			,[property_tenancy_property_name]
            ,[property_tenancy_household_name]
            ,[property_tenancy_customer_name]
            ,[property_tenancy_bond_reference]
            ,[property_tenancy_tenancy_service_bond_number]
            ,[property_tenancy_tenancy_services_property_identifier]
            ,[property_tenancy_arrears_arrangement_activated]
            ,[property_tenancy_arrears_arrangement_signed]
            ,[property_tenancy_bond_refund_sng_claim_completed]
            ,[property_tenancy_bond_refund_sng_claim_lodged]
            ,[property_tenancy_exit_point]
            ,[property_tenancy_expected_payment_day]
            ,[property_tenancy_expected_payment_frequency]
            ,[property_tenancy_leaving_reason]
            ,[property_tenancy_rent_charged_day]
            ,[property_tenancy_rent_paid_in_advance]
            ,[property_tenancy_inspection_frequency]
            ,[property_tenancy_weeks_bond_requested]
            ,[property_tenancy_manager_name]
            ,[property_tenancy_manager_email]
            ,[property_tenancy_primary_tenant_recordbaseid]
            ,[property_tenancy_second_client_name]
            ,[property_tenant_opportunity_status]
            ,[DWHBatchId]
            ,[DWHEffectiveFrom]
            ,[DWHEffectiveTo]
            ,[DWHDMLOperation]
            ,[DWHIsCurrent]
            ,[DWHSourceSystem]
            )
        VALUES
            (
                0
				, 0
				, 0
				, 'N/A'
				, 'N/A'
				, 'N/A'
				, 'N/A'
				, 'N/A'
				, 'N/A'
				, 'N/A'
				, 'N/A'
				, 'N/A'
				, 'N/A'
				, 'N/A'
				, 'N/A'
				, 'N/A'
				, 'N/A'
				, 'N/A'
				, 'N/A'
				, 'N/A'
				, 'N/A'
				, 'N/A'
				, 'N/A'
				, 'N/A'
				, 'N/A'
				, 'N/A'
				, 'N/A'
				, 'N/A'
				, 'N/A'
				, 'N/A'
				, 'N/A'
				, 0
				, @SystemDefaultEffectiveFrom
				, @SystemDefaultEffectiveTo
				, 'I'
				, 1
				, '[edw].[dim_property_tenancy]'
			),
            (
                1
				, 1
				, 1
				, 'Unknown'
				, 'Unknown'
				, 'Unknown'
				, 'Unknown'
				, 'Unknown'
				, 'Unknown'
				, 'Unknown'
				, 'Unknown'
				, 'Unknown'
				, 'Unknown'
				, 'Unknown'
				, 'Unknown'
				, 'Unknown'
				, 'Unknown'
				, 'Unknown'
				, 'Unknown'
				, 'Unknown'
				, 'Unknown'
				, 'Unknown'
				, 'Unknown'
				, 'Unknown'
				, 'Unknown'
				, 'Unknown'
				, 'Unknown'
				, 'Unknown'
				, 'Unknown'
				, 'Unknown'
				, 'Unknown'
				, 0
				, @SystemDefaultEffectiveFrom
				, @SystemDefaultEffectiveTo
				, 'I'
				, 1
				, '[edw].[dim_property_tenancy]'
			)

        -- turn the identity insert off
        SET IDENTITY_INSERT [edw].[dim_property_tenancy] OFF

    END




		if( not exists (select top(1)
        1
    from [edw].[dim_property_tenancy]
    WHERE [dim_property_tenancy_key] <= 0) )
		begin
        -- There are no records in the target; insert all
        insert into [edw].[dim_property_tenancy]
            (
            [property_tenancy_id]
            ,[dim_property_key]
			,[dim_gender_key]
            ,[property_id]
			,[ethnicity_id]
            ,[property_tenancy_tenancy_type]
            ,[property_tenancy_owning_business_unit_name]
            ,[property_tenancy_tenancy_identifier]
            ,[property_tenancy_tenancy_reference]
            ,[property_tenancy_tenancy_name]
			,[property_tenancy_property_name]
            ,[property_tenancy_household_name]
            ,[property_tenancy_customer_name]
            ,[property_tenancy_lease_agreement_datetime]
            ,[property_tenancy_tenancy_start_date]
            ,[property_tenancy_activate_tenancy_datetime]
            ,[property_tenancy_actual_start_date]
            ,[property_tenancy_fixed_term_tenancy_end_date]
            ,[property_tenancy_short_term_tenancy_end_date]
            ,[property_tenancy_expected_vacated_date]
            ,[property_tenancy_signed_msd_responsibilities_conditions_datetime]
            ,[property_tenancy_signed_sng_forms_datetime]
            ,[property_tenancy_actual_close_date]
            ,[property_tenancy_bond_lodged_date]
            ,[property_tenancy_bond_refund_lodged_date]
            ,[property_tenancy_check_bodycorp_or_residents_datetime]
            ,[property_tenancy_notice_to_vacate_date]
            ,[property_tenancy_health_disability_information_datetime]
            ,[property_tenancy_tenancy_pack_datetime]
            ,[property_tenancy_refund_lodged_date]
            ,[property_tenancy_pay_tenancy_services_by_date]
            ,[property_tenancy_short_term_in_days]
            ,[property_tenancy_bond_reference]
            ,[property_tenancy_tenancy_service_bond_number]
            ,[property_tenancy_tenancy_services_property_identifier]
            ,[property_tenancy_arrears_arrangement_activated]
            ,[property_tenancy_arrears_arrangement_signed]
            ,[property_tenancy_bond_refund_sng_claim_completed]
            ,[property_tenancy_bond_refund_sng_claim_lodged]
            ,[property_tenancy_exit_point]
            ,[property_tenancy_expected_payment_day]
            ,[property_tenancy_expected_payment_frequency]
            ,[property_tenancy_leaving_reason]
            ,[property_tenancy_rent_charged_day]
            ,[property_tenancy_rent_paid_in_advance]
            ,[property_tenancy_inspection_frequency]
            ,[property_tenancy_weeks_bond_requested]
			,[property_tenancy_weekly_rent_payable]
            ,[property_tenancy_manager_name]
            ,[property_tenancy_manager_email]
            ,[property_tenancy_rent]
            ,[property_tenancy_rent_base]
            ,[property_tenancy_primary_tenant_recordbaseid]
			,[property_tenancy_primary_tenant_gender]
			,[primary_contact_ethnicity_name]
			,[property_tenancy_primary_tenant_date_of_birth] 
            ,[property_tenancy_number_signatories]
            ,[property_tenancy_second_client_name]
            ,[property_tenancy_rent_amount_start_date]
            ,[property_tenancy_vacated_date]
			,[property_tenancy_agreement_to_extend_tenancy_received_flag]
            ,[property_tenancy_guidance_on_rent_payment_process_flag]
            ,[property_tenancy_household_composition_correct_flag]
            ,[property_tenancy_household_members_correct_flag]
            ,[property_tenancy_housing_first_flag]
            ,[property_tenancy_ignore_create_void_checklist_flag]
            ,[property_tenancy_ingoing_property_condition_report_flag]
            ,[property_tenancy_ingoing_tenancy_inspection_property_condition_flag]
            ,[property_tenancy_insulation_statement_flag]
            ,[property_tenancy_insurance_statement_flag]
            ,[property_tenancy_invoices_final_charges_to_tenant_added_flag]
            ,[property_tenancy_any_tenant_under_age_18_flag]
            ,[property_tenancy_tenancy_appropriately_housed_flag]
            ,[property_tenancy_keys_handed_over_at_tenancy_signing_flag]
            ,[property_tenancy_lease_agreement_flag]
            ,[property_tenancy_market_renter_flag]
            ,[property_tenancy_msd_notified_to_stop_redirection_flag]
            ,[property_tenancy_msd_referral_letter_received_flag]
            ,[property_tenancy_offboarding_activities_completed_flag]
            ,[property_tenancy_offer_tenant_redirection_water_payment_flag]
            ,[property_tenancy_pcr_signed_flag]
            ,[property_tenancy_pet_authorisation_paperwork_completed_flag]
            ,[property_tenancy_previous_tenancy_finalised_flag]
            ,[property_tenancy_primary_support_needs_entered_flag]
            ,[property_tenancy_health_disability_information_flag]
            ,[property_tenancy_tenancy_pack_flag]
            ,[property_tenancy_risks_entered_flag]
            ,[property_tenancy_routine_inspection_frequency_checkbox_flag]
            ,[property_tenancy_check_next_inspection_date_flag]
            ,[property_tenancy_setup_rent_review_dates_flag]
            ,[property_tenancy_signed_msd_responsibilities_conditions_flag]
            ,[property_tenancy_signed_sng_forms_flag]
            ,[property_tenancy_subsidy_flag]
            ,[property_tenancy_support_people_emergency_contacts_uptodate_flag]
            ,[property_tenancy_contribution_rent_setup_flag]
            ,[property_tenancy_initial_assessment_completed_flag]
            ,[property_tenancy_tenancy_programme_correct_flag]
            ,[property_tenancy_tenancy_started_bos_correct_details_flag]
            ,[property_tenancy_tenant_confirmed_condition_flag]
            ,[property_tenancy_tenant_confirms_ingoing_inventory_list_flag]
            ,[property_tenancy_transfer_flag]
            ,[property_tenancy_understand_sooh_process_flag]
            ,[property_tenancy_vacate_confirmation_flag]
            ,[property_tenancy_household_in_greatest_need_flag]
            ,[property_tenancy_tenant_homeless_flag]
            ,[property_tenancy_water_redirection_started_flag]
            ,[property_tenancy_welcome_visit_complete_flag]
            ,[property_tenancy_created_datetime]
            ,[property_tenancy_modified_datetime]
            ,[property_tenancy_is_delete_flag]
            ,[property_tenant_opportunity_status]
            ,[DWHBatchId]
            ,[DWHEffectiveFrom]
            ,[DWHEffectiveTo]
            ,[DWHDMLOperation]
            ,[DWHIsCurrent]
            ,[DWHSourceSystem]
            )
        select
            src.[property_tenancy_id] 
				, src.[dim_property_key]
				, src.[dim_gender_key]
				, src.[property_id]
				, src.[ethnicity_id]
				, src.[property_tenancy_tenancy_type] 
				, src.[property_tenancy_owning_business_unit_name] 
				, src.[property_tenancy_tenancy_identifier] 
				, src.[property_tenancy_tenancy_reference] 
				, src.[property_tenancy_tenancy_name]
				, src.[property_tenancy_property_name]
				, src.[property_tenancy_household_name] 
				, src.[property_tenancy_customer_name] 
				, src.[property_tenancy_lease_agreement_datetime] 
				, src.[property_tenancy_tenancy_start_date] 
				, src.[property_tenancy_activate_tenancy_datetime] 
				, src.[property_tenancy_actual_start_date] 
				, src.[property_tenancy_fixed_term_tenancy_end_date] 
				, src.[property_tenancy_short_term_tenancy_end_date] 
				, src.[property_tenancy_expected_vacated_date] 
				, src.[property_tenancy_signed_msd_responsibilities_conditions_datetime] 
				, src.[property_tenancy_signed_sng_forms_datetime] 
				, src.[property_tenancy_actual_close_date] 
				, src.[property_tenancy_bond_lodged_date] 
				, src.[property_tenancy_bond_refund_lodged_date] 
				, src.[property_tenancy_check_bodycorp_or_residents_datetime] 
				, src.[property_tenancy_notice_to_vacate_date] 
				, src.[property_tenancy_health_disability_information_datetime] 
				, src.[property_tenancy_tenancy_pack_datetime] 
				, src.[property_tenancy_refund_lodged_date] 
				, src.[property_tenancy_pay_tenancy_services_by_date] 
				, src.[property_tenancy_short_term_in_days] 
				, src.[property_tenancy_bond_reference] 
				, src.[property_tenancy_tenancy_service_bond_number] 
				, src.[property_tenancy_tenancy_services_property_identifier] 
				, src.[property_tenancy_arrears_arrangement_activated] 
				, src.[property_tenancy_arrears_arrangement_signed] 
				, src.[property_tenancy_bond_refund_sng_claim_completed] 
				, src.[property_tenancy_bond_refund_sng_claim_lodged] 
				, src.[property_tenancy_exit_point] 
				, src.[property_tenancy_expected_payment_day] 
				, src.[property_tenancy_expected_payment_frequency] 
				, src.[property_tenancy_leaving_reason] 
				, src.[property_tenancy_rent_charged_day] 
				, src.[property_tenancy_rent_paid_in_advance] 
				, src.[property_tenancy_inspection_frequency] 
				, src.[property_tenancy_weeks_bond_requested]
				, src.[property_tenancy_weekly_rent_payable]
				, src.[property_tenancy_manager_name] 
				, src.[property_tenancy_manager_email] 
				, src.[property_tenancy_rent] 
				, src.[property_tenancy_rent_base]
				, src.[property_tenancy_primary_tenant_recordbaseid]
				, src.[property_tenancy_primary_tenant_gender]
			    , src.[primary_contact_ethnicity_name]
				, src.[property_tenancy_primary_tenant_date_of_birth] 
				, src.[property_tenancy_number_signatories] 
				, src.[property_tenancy_second_client_name] 
				, src.[property_tenancy_rent_amount_start_date] 
				, src.[property_tenancy_vacated_date]
				, src.[property_tenancy_agreement_to_extend_tenancy_received_flag]
				, src.[property_tenancy_guidance_on_rent_payment_process_flag] 
				, src.[property_tenancy_household_composition_correct_flag] 
				, src.[property_tenancy_household_members_correct_flag] 
				, src.[property_tenancy_housing_first_flag] 
				, src.[property_tenancy_ignore_create_void_checklist_flag] 
				, src.[property_tenancy_ingoing_property_condition_report_flag] 
				, src.[property_tenancy_ingoing_tenancy_inspection_property_condition_flag] 
				, src.[property_tenancy_insulation_statement_flag] 
				, src.[property_tenancy_insurance_statement_flag] 
				, src.[property_tenancy_invoices_final_charges_to_tenant_added_flag] 
				, src.[property_tenancy_any_tenant_under_age_18_flag] 
				, src.[property_tenancy_tenancy_appropriately_housed_flag] 
				, src.[property_tenancy_keys_handed_over_at_tenancy_signing_flag] 
				, src.[property_tenancy_lease_agreement_flag] 
				, src.[property_tenancy_market_renter_flag] 
				, src.[property_tenancy_msd_notified_to_stop_redirection_flag] 
				, src.[property_tenancy_msd_referral_letter_received_flag] 
				, src.[property_tenancy_offboarding_activities_completed_flag] 
				, src.[property_tenancy_offer_tenant_redirection_water_payment_flag] 
				, src.[property_tenancy_pcr_signed_flag] 
				, src.[property_tenancy_pet_authorisation_paperwork_completed_flag] 
				, src.[property_tenancy_previous_tenancy_finalised_flag] 
				, src.[property_tenancy_primary_support_needs_entered_flag] 
				, src.[property_tenancy_health_disability_information_flag] 
				, src.[property_tenancy_tenancy_pack_flag] 
				, src.[property_tenancy_risks_entered_flag] 
				, src.[property_tenancy_routine_inspection_frequency_checkbox_flag] 
				, src.[property_tenancy_check_next_inspection_date_flag] 
				, src.[property_tenancy_setup_rent_review_dates_flag] 
				, src.[property_tenancy_signed_msd_responsibilities_conditions_flag] 
				, src.[property_tenancy_signed_sng_forms_flag] 
				, src.[property_tenancy_subsidy_flag] 
				, src.[property_tenancy_support_people_emergency_contacts_uptodate_flag] 
				, src.[property_tenancy_contribution_rent_setup_flag] 
				, src.[property_tenancy_initial_assessment_completed_flag] 
				, src.[property_tenancy_tenancy_programme_correct_flag] 
				, src.[property_tenancy_tenancy_started_bos_correct_details_flag] 
				, src.[property_tenancy_tenant_confirmed_condition_flag] 
				, src.[property_tenancy_tenant_confirms_ingoing_inventory_list_flag] 
				, src.[property_tenancy_transfer_flag] 
				, src.[property_tenancy_understand_sooh_process_flag] 
				, src.[property_tenancy_vacate_confirmation_flag] 
				, src.[property_tenancy_household_in_greatest_need_flag] 
				, src.[property_tenancy_tenant_homeless_flag] 
				, src.[property_tenancy_water_redirection_started_flag] 
				, src.[property_tenancy_welcome_visit_complete_flag] 
				, src.[property_tenancy_created_datetime] 
				, src.[property_tenancy_modified_datetime] 
				, src.[property_tenancy_is_delete_flag] 
				, src.[property_tenant_opportunity_status]
				, @BatchID as [DWHBatchId]
				, convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				, convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				, 'I' as [DWHDMLOperation]
				, 1 as [DWHIsCurrent]
				, @SourceSystem as [DWHSourceSystem]
        from [Staging].[ODSETLdim_property_tenancy] as src;


    end else begin
        -- Fetch the current high-water maximum values
        declare @property_tenancy_modified_datetime datetime2(7) = null;

        execute [edw].[GetHighwaterForedwdim_property_tenancy] @property_tenancy_modified_datetime output;

        merge into [edw].[dim_property_tenancy] as trg
			using 
			(
				select
            src.[property_tenancy_id] 
				, src.[dim_property_key]
				, src.[dim_gender_key]
				, src.[property_id]
				, src.[ethnicity_id]
				, src.[property_tenancy_tenancy_type] 
				, src.[property_tenancy_owning_business_unit_name] 
				, src.[property_tenancy_tenancy_identifier] 
				, src.[property_tenancy_tenancy_reference] 
				, src.[property_tenancy_tenancy_name]
				, src.[property_tenancy_property_name]
				, src.[property_tenancy_household_name] 
				, src.[property_tenancy_customer_name] 
				, src.[property_tenancy_lease_agreement_datetime] 
				, src.[property_tenancy_tenancy_start_date] 
				, src.[property_tenancy_activate_tenancy_datetime] 
				, src.[property_tenancy_actual_start_date] 
				, src.[property_tenancy_fixed_term_tenancy_end_date] 
				, src.[property_tenancy_short_term_tenancy_end_date] 
				, src.[property_tenancy_expected_vacated_date] 
				, src.[property_tenancy_signed_msd_responsibilities_conditions_datetime] 
				, src.[property_tenancy_signed_sng_forms_datetime] 
				, src.[property_tenancy_actual_close_date] 
				, src.[property_tenancy_bond_lodged_date] 
				, src.[property_tenancy_bond_refund_lodged_date] 
				, src.[property_tenancy_check_bodycorp_or_residents_datetime] 
				, src.[property_tenancy_notice_to_vacate_date] 
				, src.[property_tenancy_health_disability_information_datetime] 
				, src.[property_tenancy_tenancy_pack_datetime] 
				, src.[property_tenancy_refund_lodged_date] 
				, src.[property_tenancy_pay_tenancy_services_by_date] 
				, src.[property_tenancy_short_term_in_days] 
				, src.[property_tenancy_bond_reference] 
				, src.[property_tenancy_tenancy_service_bond_number] 
				, src.[property_tenancy_tenancy_services_property_identifier] 
				, src.[property_tenancy_arrears_arrangement_activated] 
				, src.[property_tenancy_arrears_arrangement_signed] 
				, src.[property_tenancy_bond_refund_sng_claim_completed] 
				, src.[property_tenancy_bond_refund_sng_claim_lodged] 
				, src.[property_tenancy_exit_point] 
				, src.[property_tenancy_expected_payment_day] 
				, src.[property_tenancy_expected_payment_frequency] 
				, src.[property_tenancy_leaving_reason] 
				, src.[property_tenancy_rent_charged_day] 
				, src.[property_tenancy_rent_paid_in_advance] 
				, src.[property_tenancy_inspection_frequency] 
				, src.[property_tenancy_weeks_bond_requested] 
				, src.[property_tenancy_weekly_rent_payable]
				, src.[property_tenancy_manager_name] 
				, src.[property_tenancy_manager_email] 
				, src.[property_tenancy_rent] 
				, src.[property_tenancy_rent_base]
				, src.[property_tenancy_primary_tenant_recordbaseid]
				, src.[property_tenancy_primary_tenant_gender]
			    , src.[primary_contact_ethnicity_name]
				, src.[property_tenancy_primary_tenant_date_of_birth] 
				, src.[property_tenancy_number_signatories] 
				, src.[property_tenancy_second_client_name] 
				, src.[property_tenancy_rent_amount_start_date]
				, src.[property_tenancy_vacated_date]
				, src.[property_tenancy_agreement_to_extend_tenancy_received_flag]
				, src.[property_tenancy_guidance_on_rent_payment_process_flag] 
				, src.[property_tenancy_household_composition_correct_flag] 
				, src.[property_tenancy_household_members_correct_flag] 
				, src.[property_tenancy_housing_first_flag] 
				, src.[property_tenancy_ignore_create_void_checklist_flag] 
				, src.[property_tenancy_ingoing_property_condition_report_flag] 
				, src.[property_tenancy_ingoing_tenancy_inspection_property_condition_flag] 
				, src.[property_tenancy_insulation_statement_flag] 
				, src.[property_tenancy_insurance_statement_flag] 
				, src.[property_tenancy_invoices_final_charges_to_tenant_added_flag] 
				, src.[property_tenancy_any_tenant_under_age_18_flag] 
				, src.[property_tenancy_tenancy_appropriately_housed_flag] 
				, src.[property_tenancy_keys_handed_over_at_tenancy_signing_flag] 
				, src.[property_tenancy_lease_agreement_flag] 
				, src.[property_tenancy_market_renter_flag] 
				, src.[property_tenancy_msd_notified_to_stop_redirection_flag] 
				, src.[property_tenancy_msd_referral_letter_received_flag] 
				, src.[property_tenancy_offboarding_activities_completed_flag] 
				, src.[property_tenancy_offer_tenant_redirection_water_payment_flag] 
				, src.[property_tenancy_pcr_signed_flag] 
				, src.[property_tenancy_pet_authorisation_paperwork_completed_flag] 
				, src.[property_tenancy_previous_tenancy_finalised_flag] 
				, src.[property_tenancy_primary_support_needs_entered_flag] 
				, src.[property_tenancy_health_disability_information_flag] 
				, src.[property_tenancy_tenancy_pack_flag] 
				, src.[property_tenancy_risks_entered_flag] 
				, src.[property_tenancy_routine_inspection_frequency_checkbox_flag] 
				, src.[property_tenancy_check_next_inspection_date_flag] 
				, src.[property_tenancy_setup_rent_review_dates_flag] 
				, src.[property_tenancy_signed_msd_responsibilities_conditions_flag] 
				, src.[property_tenancy_signed_sng_forms_flag] 
				, src.[property_tenancy_subsidy_flag] 
				, src.[property_tenancy_support_people_emergency_contacts_uptodate_flag] 
				, src.[property_tenancy_contribution_rent_setup_flag] 
				, src.[property_tenancy_initial_assessment_completed_flag] 
				, src.[property_tenancy_tenancy_programme_correct_flag] 
				, src.[property_tenancy_tenancy_started_bos_correct_details_flag] 
				, src.[property_tenancy_tenant_confirmed_condition_flag] 
				, src.[property_tenancy_tenant_confirms_ingoing_inventory_list_flag] 
				, src.[property_tenancy_transfer_flag] 
				, src.[property_tenancy_understand_sooh_process_flag] 
				, src.[property_tenancy_vacate_confirmation_flag] 
				, src.[property_tenancy_household_in_greatest_need_flag] 
				, src.[property_tenancy_tenant_homeless_flag] 
				, src.[property_tenancy_water_redirection_started_flag] 
				, src.[property_tenancy_welcome_visit_complete_flag] 
				, src.[property_tenancy_created_datetime] 
				, src.[property_tenancy_modified_datetime] 
				, src.[property_tenancy_is_delete_flag] 
				, src.[property_tenant_opportunity_status]
				, @BatchID as [DWHBatchId]
				, convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				, convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				, 'I' as [DWHDMLOperation]
				, 1 as [DWHIsCurrent]
				, @SourceSystem as [DWHSourceSystem]
        from [Staging].[ODSETLdim_property_tenancy] as src
			) as src on (src.[property_tenancy_id] = trg.[property_tenancy_id] and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
			select src.Property_id, src.[property_tenancy_tenancy_type], src.[property_tenancy_owning_business_unit_name], src.[property_tenancy_tenancy_identifier], src.[property_tenancy_tenancy_reference], src.[property_tenancy_tenancy_name], src.[property_tenancy_property_name], src.[property_tenancy_household_name], src.[property_tenancy_customer_name], src.[property_tenancy_lease_agreement_datetime], src.[property_tenancy_tenancy_start_date], src.[property_tenancy_activate_tenancy_datetime], src.[property_tenancy_actual_start_date], src.[property_tenancy_fixed_term_tenancy_end_date], src.[property_tenancy_short_term_tenancy_end_date], src.[property_tenancy_expected_vacated_date], src.[property_tenancy_signed_msd_responsibilities_conditions_datetime], src.[property_tenancy_signed_sng_forms_datetime], src.[property_tenancy_actual_close_date], src.[property_tenancy_bond_lodged_date], src.[property_tenancy_bond_refund_lodged_date], src.[property_tenancy_check_bodycorp_or_residents_datetime], src.[property_tenancy_notice_to_vacate_date], src.[property_tenancy_health_disability_information_datetime], src.[property_tenancy_tenancy_pack_datetime], src.[property_tenancy_refund_lodged_date], src.[property_tenancy_pay_tenancy_services_by_date], src.[property_tenancy_short_term_in_days], src.[property_tenancy_bond_reference], src.[property_tenancy_tenancy_service_bond_number], src.[property_tenancy_tenancy_services_property_identifier], src.[property_tenancy_arrears_arrangement_activated], src.[property_tenancy_arrears_arrangement_signed], src.[property_tenancy_bond_refund_sng_claim_completed], src.[property_tenancy_bond_refund_sng_claim_lodged], src.[property_tenancy_exit_point], src.[property_tenancy_expected_payment_day], src.[property_tenancy_expected_payment_frequency], src.[property_tenancy_leaving_reason], src.[property_tenancy_rent_charged_day], src.[property_tenancy_rent_paid_in_advance], src.[property_tenancy_inspection_frequency], src.[property_tenancy_weeks_bond_requested], src.[property_tenancy_weekly_rent_payable], src.[property_tenancy_manager_name], src.[property_tenancy_manager_email], src.[property_tenancy_rent], src.[property_tenancy_rent_base], src.[property_tenancy_primary_tenant_recordbaseid], src.[property_tenancy_primary_tenant_gender] , src.[primary_contact_ethnicity_name], src.[property_tenancy_primary_tenant_date_of_birth],  src.[property_tenancy_number_signatories], src.[property_tenancy_second_client_name], src.[property_tenancy_rent_amount_start_date], src.[property_tenancy_vacated_date],src.[property_tenancy_agreement_to_extend_tenancy_received_flag], src.[property_tenancy_guidance_on_rent_payment_process_flag], src.[property_tenancy_household_composition_correct_flag], src.[property_tenancy_household_members_correct_flag], src.[property_tenancy_housing_first_flag], src.[property_tenancy_ignore_create_void_checklist_flag], src.[property_tenancy_ingoing_property_condition_report_flag], src.[property_tenancy_ingoing_tenancy_inspection_property_condition_flag], src.[property_tenancy_insulation_statement_flag], src.[property_tenancy_insurance_statement_flag], src.[property_tenancy_invoices_final_charges_to_tenant_added_flag], src.[property_tenancy_any_tenant_under_age_18_flag], src.[property_tenancy_tenancy_appropriately_housed_flag], src.[property_tenancy_keys_handed_over_at_tenancy_signing_flag], src.[property_tenancy_lease_agreement_flag], src.[property_tenancy_market_renter_flag], src.[property_tenancy_msd_notified_to_stop_redirection_flag], src.[property_tenancy_msd_referral_letter_received_flag], src.[property_tenancy_offboarding_activities_completed_flag], src.[property_tenancy_offer_tenant_redirection_water_payment_flag], src.[property_tenancy_pcr_signed_flag], src.[property_tenancy_pet_authorisation_paperwork_completed_flag], src.[property_tenancy_previous_tenancy_finalised_flag], src.[property_tenancy_primary_support_needs_entered_flag], src.[property_tenancy_health_disability_information_flag], src.[property_tenancy_tenancy_pack_flag], src.[property_tenancy_risks_entered_flag], src.[property_tenancy_routine_inspection_frequency_checkbox_flag], src.[property_tenancy_check_next_inspection_date_flag], src.[property_tenancy_setup_rent_review_dates_flag], src.[property_tenancy_signed_msd_responsibilities_conditions_flag], src.[property_tenancy_signed_sng_forms_flag], src.[property_tenancy_subsidy_flag], src.[property_tenancy_support_people_emergency_contacts_uptodate_flag], src.[property_tenancy_contribution_rent_setup_flag], src.[property_tenancy_initial_assessment_completed_flag], src.[property_tenancy_tenancy_programme_correct_flag], src.[property_tenancy_tenancy_started_bos_correct_details_flag], src.[property_tenancy_tenant_confirmed_condition_flag], src.[property_tenancy_tenant_confirms_ingoing_inventory_list_flag], src.[property_tenancy_transfer_flag], src.[property_tenancy_understand_sooh_process_flag], src.[property_tenancy_vacate_confirmation_flag], src.[property_tenancy_household_in_greatest_need_flag], src.[property_tenancy_tenant_homeless_flag], src.[property_tenancy_water_redirection_started_flag], src.[property_tenancy_welcome_visit_complete_flag], src.[property_tenancy_created_datetime], src.[property_tenancy_is_delete_flag] , src.[property_tenant_opportunity_status], case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
        except
            select trg.Property_id, trg.[property_tenancy_tenancy_type], trg.[property_tenancy_owning_business_unit_name], trg.[property_tenancy_tenancy_identifier], trg.[property_tenancy_tenancy_reference], trg.[property_tenancy_tenancy_name] ,trg.[property_tenancy_property_name], trg.[property_tenancy_household_name], trg.[property_tenancy_customer_name], trg.[property_tenancy_lease_agreement_datetime], trg.[property_tenancy_tenancy_start_date], trg.[property_tenancy_activate_tenancy_datetime], trg.[property_tenancy_actual_start_date], trg.[property_tenancy_fixed_term_tenancy_end_date], trg.[property_tenancy_short_term_tenancy_end_date], trg.[property_tenancy_expected_vacated_date], trg.[property_tenancy_signed_msd_responsibilities_conditions_datetime], trg.[property_tenancy_signed_sng_forms_datetime], trg.[property_tenancy_actual_close_date], trg.[property_tenancy_bond_lodged_date], trg.[property_tenancy_bond_refund_lodged_date], trg.[property_tenancy_check_bodycorp_or_residents_datetime], trg.[property_tenancy_notice_to_vacate_date], trg.[property_tenancy_health_disability_information_datetime], trg.[property_tenancy_tenancy_pack_datetime], trg.[property_tenancy_refund_lodged_date], trg.[property_tenancy_pay_tenancy_services_by_date], trg.[property_tenancy_short_term_in_days], trg.[property_tenancy_bond_reference], trg.[property_tenancy_tenancy_service_bond_number], trg.[property_tenancy_tenancy_services_property_identifier], trg.[property_tenancy_arrears_arrangement_activated], trg.[property_tenancy_arrears_arrangement_signed], trg.[property_tenancy_bond_refund_sng_claim_completed], trg.[property_tenancy_bond_refund_sng_claim_lodged], trg.[property_tenancy_exit_point], trg.[property_tenancy_expected_payment_day], trg.[property_tenancy_expected_payment_frequency], trg.[property_tenancy_leaving_reason], trg.[property_tenancy_rent_charged_day], trg.[property_tenancy_rent_paid_in_advance], trg.[property_tenancy_inspection_frequency], trg.[property_tenancy_weeks_bond_requested], trg.[property_tenancy_weekly_rent_payable], trg.[property_tenancy_manager_name], trg.[property_tenancy_manager_email], trg.[property_tenancy_rent], trg.[property_tenancy_rent_base], trg.[property_tenancy_primary_tenant_recordbaseid], trg.[property_tenancy_primary_tenant_gender] , trg.[primary_contact_ethnicity_name], trg.[property_tenancy_primary_tenant_date_of_birth] , trg.[property_tenancy_number_signatories], trg.[property_tenancy_second_client_name], trg.[property_tenancy_rent_amount_start_date], trg.[property_tenancy_vacated_date],trg.[property_tenancy_agreement_to_extend_tenancy_received_flag], trg.[property_tenancy_guidance_on_rent_payment_process_flag], trg.[property_tenancy_household_composition_correct_flag], trg.[property_tenancy_household_members_correct_flag], trg.[property_tenancy_housing_first_flag], trg.[property_tenancy_ignore_create_void_checklist_flag], trg.[property_tenancy_ingoing_property_condition_report_flag], trg.[property_tenancy_ingoing_tenancy_inspection_property_condition_flag], trg.[property_tenancy_insulation_statement_flag], trg.[property_tenancy_insurance_statement_flag], trg.[property_tenancy_invoices_final_charges_to_tenant_added_flag], trg.[property_tenancy_any_tenant_under_age_18_flag], trg.[property_tenancy_tenancy_appropriately_housed_flag], trg.[property_tenancy_keys_handed_over_at_tenancy_signing_flag], trg.[property_tenancy_lease_agreement_flag], trg.[property_tenancy_market_renter_flag], trg.[property_tenancy_msd_notified_to_stop_redirection_flag], trg.[property_tenancy_msd_referral_letter_received_flag], trg.[property_tenancy_offboarding_activities_completed_flag], trg.[property_tenancy_offer_tenant_redirection_water_payment_flag], trg.[property_tenancy_pcr_signed_flag], trg.[property_tenancy_pet_authorisation_paperwork_completed_flag], trg.[property_tenancy_previous_tenancy_finalised_flag], trg.[property_tenancy_primary_support_needs_entered_flag], trg.[property_tenancy_health_disability_information_flag], trg.[property_tenancy_tenancy_pack_flag], trg.[property_tenancy_risks_entered_flag], trg.[property_tenancy_routine_inspection_frequency_checkbox_flag], trg.[property_tenancy_check_next_inspection_date_flag], trg.[property_tenancy_setup_rent_review_dates_flag], trg.[property_tenancy_signed_msd_responsibilities_conditions_flag], trg.[property_tenancy_signed_sng_forms_flag], trg.[property_tenancy_subsidy_flag], trg.[property_tenancy_support_people_emergency_contacts_uptodate_flag], trg.[property_tenancy_contribution_rent_setup_flag], trg.[property_tenancy_initial_assessment_completed_flag], trg.[property_tenancy_tenancy_programme_correct_flag], trg.[property_tenancy_tenancy_started_bos_correct_details_flag], trg.[property_tenancy_tenant_confirmed_condition_flag], trg.[property_tenancy_tenant_confirms_ingoing_inventory_list_flag], trg.[property_tenancy_transfer_flag], trg.[property_tenancy_understand_sooh_process_flag], trg.[property_tenancy_vacate_confirmation_flag], trg.[property_tenancy_household_in_greatest_need_flag], trg.[property_tenancy_tenant_homeless_flag], trg.[property_tenancy_water_redirection_started_flag], trg.[property_tenancy_welcome_visit_complete_flag], trg.[property_tenancy_created_datetime], trg.[property_tenancy_is_delete_flag], trg.[property_tenant_opportunity_status], 'X'
			) then  
				update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0

			-- Soft delete missing records
			when not matched by source 
			and trg.[dim_property_tenancy_key] > 0
            and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo
            and trg.[DWHDMLOperation] <> 'D'
            and trg.[property_tenancy_modified_datetime] > @property_tenancy_modified_datetime 
			then update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0

			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [property_tenancy_id] 
					,[dim_property_key]
					,[dim_gender_key]
				    ,[property_id]
				    ,[ethnicity_id]
					,[property_tenancy_tenancy_type] 
					,[property_tenancy_owning_business_unit_name] 
					,[property_tenancy_tenancy_identifier] 
					,[property_tenancy_tenancy_reference] 
					,[property_tenancy_tenancy_name]
					,[property_tenancy_property_name]
					,[property_tenancy_household_name] 
					,[property_tenancy_customer_name] 
					,[property_tenancy_lease_agreement_datetime] 
					,[property_tenancy_tenancy_start_date] 
					,[property_tenancy_activate_tenancy_datetime] 
					,[property_tenancy_actual_start_date] 
					,[property_tenancy_fixed_term_tenancy_end_date] 
					,[property_tenancy_short_term_tenancy_end_date] 
					,[property_tenancy_expected_vacated_date] 
					,[property_tenancy_signed_msd_responsibilities_conditions_datetime] 
					,[property_tenancy_signed_sng_forms_datetime] 
					,[property_tenancy_actual_close_date] 
					,[property_tenancy_bond_lodged_date] 
					,[property_tenancy_bond_refund_lodged_date] 
					,[property_tenancy_check_bodycorp_or_residents_datetime] 
					,[property_tenancy_notice_to_vacate_date] 
					,[property_tenancy_health_disability_information_datetime] 
					,[property_tenancy_tenancy_pack_datetime] 
					,[property_tenancy_refund_lodged_date] 
					,[property_tenancy_pay_tenancy_services_by_date] 
					,[property_tenancy_short_term_in_days] 
					,[property_tenancy_bond_reference] 
					,[property_tenancy_tenancy_service_bond_number] 
					,[property_tenancy_tenancy_services_property_identifier] 
					,[property_tenancy_arrears_arrangement_activated] 
					,[property_tenancy_arrears_arrangement_signed] 
					,[property_tenancy_bond_refund_sng_claim_completed] 
					,[property_tenancy_bond_refund_sng_claim_lodged] 
					,[property_tenancy_exit_point] 
					,[property_tenancy_expected_payment_day] 
					,[property_tenancy_expected_payment_frequency] 
					,[property_tenancy_leaving_reason] 
					,[property_tenancy_rent_charged_day] 
					,[property_tenancy_rent_paid_in_advance] 
					,[property_tenancy_inspection_frequency] 
					,[property_tenancy_weeks_bond_requested]
					,[property_tenancy_weekly_rent_payable]
					,[property_tenancy_manager_name] 
					,[property_tenancy_manager_email] 
					,[property_tenancy_rent] 
					,[property_tenancy_rent_base]
					,[property_tenancy_primary_tenant_recordbaseid]
					,[property_tenancy_primary_tenant_gender]
			        ,[primary_contact_ethnicity_name]
					,[property_tenancy_primary_tenant_date_of_birth] 
					,[property_tenancy_number_signatories] 
					,[property_tenancy_second_client_name] 
					,[property_tenancy_rent_amount_start_date] 
					,[property_tenancy_vacated_date]
					,[property_tenancy_agreement_to_extend_tenancy_received_flag]
					,[property_tenancy_guidance_on_rent_payment_process_flag] 
					,[property_tenancy_household_composition_correct_flag] 
					,[property_tenancy_household_members_correct_flag] 
					,[property_tenancy_housing_first_flag] 
					,[property_tenancy_ignore_create_void_checklist_flag] 
					,[property_tenancy_ingoing_property_condition_report_flag] 
					,[property_tenancy_ingoing_tenancy_inspection_property_condition_flag] 
					,[property_tenancy_insulation_statement_flag] 
					,[property_tenancy_insurance_statement_flag] 
					,[property_tenancy_invoices_final_charges_to_tenant_added_flag] 
					,[property_tenancy_any_tenant_under_age_18_flag] 
					,[property_tenancy_tenancy_appropriately_housed_flag] 
					,[property_tenancy_keys_handed_over_at_tenancy_signing_flag] 
					,[property_tenancy_lease_agreement_flag] 
					,[property_tenancy_market_renter_flag] 
					,[property_tenancy_msd_notified_to_stop_redirection_flag] 
					,[property_tenancy_msd_referral_letter_received_flag] 
					,[property_tenancy_offboarding_activities_completed_flag] 
					,[property_tenancy_offer_tenant_redirection_water_payment_flag] 
					,[property_tenancy_pcr_signed_flag] 
					,[property_tenancy_pet_authorisation_paperwork_completed_flag] 
					,[property_tenancy_previous_tenancy_finalised_flag] 
					,[property_tenancy_primary_support_needs_entered_flag] 
					,[property_tenancy_health_disability_information_flag] 
					,[property_tenancy_tenancy_pack_flag] 
					,[property_tenancy_risks_entered_flag] 
					,[property_tenancy_routine_inspection_frequency_checkbox_flag] 
					,[property_tenancy_check_next_inspection_date_flag] 
					,[property_tenancy_setup_rent_review_dates_flag] 
					,[property_tenancy_signed_msd_responsibilities_conditions_flag] 
					,[property_tenancy_signed_sng_forms_flag] 
					,[property_tenancy_subsidy_flag] 
					,[property_tenancy_support_people_emergency_contacts_uptodate_flag] 
					,[property_tenancy_contribution_rent_setup_flag] 
					,[property_tenancy_initial_assessment_completed_flag] 
					,[property_tenancy_tenancy_programme_correct_flag] 
					,[property_tenancy_tenancy_started_bos_correct_details_flag] 
					,[property_tenancy_tenant_confirmed_condition_flag] 
					,[property_tenancy_tenant_confirms_ingoing_inventory_list_flag] 
					,[property_tenancy_transfer_flag] 
					,[property_tenancy_understand_sooh_process_flag] 
					,[property_tenancy_vacate_confirmation_flag] 
					,[property_tenancy_household_in_greatest_need_flag] 
					,[property_tenancy_tenant_homeless_flag] 
					,[property_tenancy_water_redirection_started_flag] 
					,[property_tenancy_welcome_visit_complete_flag] 
					,[property_tenancy_created_datetime] 
					,[property_tenancy_modified_datetime] 
					,[property_tenancy_is_delete_flag] 
					,[property_tenant_opportunity_status]
					,[DWHBatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperation] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[property_tenancy_id] 
					,src.[dim_property_key]
					, src.[dim_gender_key]
					, src.[property_id]
					, src.[ethnicity_id]
					,src.[property_tenancy_tenancy_type] 
					,src.[property_tenancy_owning_business_unit_name] 
					,src.[property_tenancy_tenancy_identifier] 
					,src.[property_tenancy_tenancy_reference] 
					,src.[property_tenancy_tenancy_name] 
					,src.[property_tenancy_property_name]
					,src.[property_tenancy_household_name] 
					,src.[property_tenancy_customer_name] 
					,src.[property_tenancy_lease_agreement_datetime] 
					,src.[property_tenancy_tenancy_start_date] 
					,src.[property_tenancy_activate_tenancy_datetime] 
					,src.[property_tenancy_actual_start_date] 
					,src.[property_tenancy_fixed_term_tenancy_end_date] 
					,src.[property_tenancy_short_term_tenancy_end_date] 
					,src.[property_tenancy_expected_vacated_date] 
					,src.[property_tenancy_signed_msd_responsibilities_conditions_datetime] 
					,src.[property_tenancy_signed_sng_forms_datetime] 
					,src.[property_tenancy_actual_close_date] 
					,src.[property_tenancy_bond_lodged_date] 
					,src.[property_tenancy_bond_refund_lodged_date] 
					,src.[property_tenancy_check_bodycorp_or_residents_datetime] 
					,src.[property_tenancy_notice_to_vacate_date] 
					,src.[property_tenancy_health_disability_information_datetime] 
					,src.[property_tenancy_tenancy_pack_datetime] 
					,src.[property_tenancy_refund_lodged_date] 
					,src.[property_tenancy_pay_tenancy_services_by_date] 
					,src.[property_tenancy_short_term_in_days] 
					,src.[property_tenancy_bond_reference] 
					,src.[property_tenancy_tenancy_service_bond_number] 
					,src.[property_tenancy_tenancy_services_property_identifier] 
					,src.[property_tenancy_arrears_arrangement_activated] 
					,src.[property_tenancy_arrears_arrangement_signed] 
					,src.[property_tenancy_bond_refund_sng_claim_completed] 
					,src.[property_tenancy_bond_refund_sng_claim_lodged] 
					,src.[property_tenancy_exit_point] 
					,src.[property_tenancy_expected_payment_day] 
					,src.[property_tenancy_expected_payment_frequency] 
					,src.[property_tenancy_leaving_reason] 
					,src.[property_tenancy_rent_charged_day] 
					,src.[property_tenancy_rent_paid_in_advance] 
					,src.[property_tenancy_inspection_frequency] 
					,src.[property_tenancy_weeks_bond_requested]
					,src.[property_tenancy_weekly_rent_payable]
					,src.[property_tenancy_manager_name] 
					,src.[property_tenancy_manager_email] 
					,src.[property_tenancy_rent] 
					,src.[property_tenancy_rent_base]
					,src.[property_tenancy_primary_tenant_recordbaseid]
					,src.[property_tenancy_primary_tenant_gender]
			        ,src.[primary_contact_ethnicity_name]
					,src.[property_tenancy_primary_tenant_date_of_birth] 
					,src.[property_tenancy_number_signatories] 
					,src.[property_tenancy_second_client_name] 
					,src.[property_tenancy_rent_amount_start_date] 
					,src.[property_tenancy_vacated_date]
					,src.[property_tenancy_agreement_to_extend_tenancy_received_flag]
					,src.[property_tenancy_guidance_on_rent_payment_process_flag] 
					,src.[property_tenancy_household_composition_correct_flag] 
					,src.[property_tenancy_household_members_correct_flag] 
					,src.[property_tenancy_housing_first_flag] 
					,src.[property_tenancy_ignore_create_void_checklist_flag] 
					,src.[property_tenancy_ingoing_property_condition_report_flag] 
					,src.[property_tenancy_ingoing_tenancy_inspection_property_condition_flag] 
					,src.[property_tenancy_insulation_statement_flag] 
					,src.[property_tenancy_insurance_statement_flag] 
					,src.[property_tenancy_invoices_final_charges_to_tenant_added_flag] 
					,src.[property_tenancy_any_tenant_under_age_18_flag] 
					,src.[property_tenancy_tenancy_appropriately_housed_flag] 
					,src.[property_tenancy_keys_handed_over_at_tenancy_signing_flag] 
					,src.[property_tenancy_lease_agreement_flag] 
					,src.[property_tenancy_market_renter_flag] 
					,src.[property_tenancy_msd_notified_to_stop_redirection_flag] 
					,src.[property_tenancy_msd_referral_letter_received_flag] 
					,src.[property_tenancy_offboarding_activities_completed_flag] 
					,src.[property_tenancy_offer_tenant_redirection_water_payment_flag] 
					,src.[property_tenancy_pcr_signed_flag] 
					,src.[property_tenancy_pet_authorisation_paperwork_completed_flag] 
					,src.[property_tenancy_previous_tenancy_finalised_flag] 
					,src.[property_tenancy_primary_support_needs_entered_flag] 
					,src.[property_tenancy_health_disability_information_flag] 
					,src.[property_tenancy_tenancy_pack_flag] 
					,src.[property_tenancy_risks_entered_flag] 
					,src.[property_tenancy_routine_inspection_frequency_checkbox_flag] 
					,src.[property_tenancy_check_next_inspection_date_flag] 
					,src.[property_tenancy_setup_rent_review_dates_flag] 
					,src.[property_tenancy_signed_msd_responsibilities_conditions_flag] 
					,src.[property_tenancy_signed_sng_forms_flag] 
					,src.[property_tenancy_subsidy_flag] 
					,src.[property_tenancy_support_people_emergency_contacts_uptodate_flag] 
					,src.[property_tenancy_contribution_rent_setup_flag] 
					,src.[property_tenancy_initial_assessment_completed_flag] 
					,src.[property_tenancy_tenancy_programme_correct_flag] 
					,src.[property_tenancy_tenancy_started_bos_correct_details_flag] 
					,src.[property_tenancy_tenant_confirmed_condition_flag] 
					,src.[property_tenancy_tenant_confirms_ingoing_inventory_list_flag] 
					,src.[property_tenancy_transfer_flag] 
					,src.[property_tenancy_understand_sooh_process_flag] 
					,src.[property_tenancy_vacate_confirmation_flag] 
					,src.[property_tenancy_household_in_greatest_need_flag] 
					,src.[property_tenancy_tenant_homeless_flag] 
					,src.[property_tenancy_water_redirection_started_flag] 
					,src.[property_tenancy_welcome_visit_complete_flag] 
					,src.[property_tenancy_created_datetime] 
					,src.[property_tenancy_modified_datetime] 
					,src.[property_tenancy_is_delete_flag] 
					,src.[property_tenant_opportunity_status]
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[property_tenancy_id],inserted.[property_tenancy_id]), $action As [MergeAction] into #SummaryOfChanges;

        -- Insert new versions of previously updated records (Updates and Deletes)
        insert into [edw].[dim_property_tenancy]
            (
            [property_tenancy_id]
            ,[dim_property_key]
            ,[dim_gender_key]
		    ,[property_id]
			,[ethnicity_id]
            ,[property_tenancy_tenancy_type]
            ,[property_tenancy_owning_business_unit_name]
            ,[property_tenancy_tenancy_identifier]
            ,[property_tenancy_tenancy_reference]
            ,[property_tenancy_tenancy_name]
			,[property_tenancy_property_name]
            ,[property_tenancy_household_name]
            ,[property_tenancy_customer_name]
            ,[property_tenancy_lease_agreement_datetime]
            ,[property_tenancy_tenancy_start_date]
            ,[property_tenancy_activate_tenancy_datetime]
            ,[property_tenancy_actual_start_date]
            ,[property_tenancy_fixed_term_tenancy_end_date]
            ,[property_tenancy_short_term_tenancy_end_date]
            ,[property_tenancy_expected_vacated_date]
            ,[property_tenancy_signed_msd_responsibilities_conditions_datetime]
            ,[property_tenancy_signed_sng_forms_datetime]
            ,[property_tenancy_actual_close_date]
            ,[property_tenancy_bond_lodged_date]
            ,[property_tenancy_bond_refund_lodged_date]
            ,[property_tenancy_check_bodycorp_or_residents_datetime]
            ,[property_tenancy_notice_to_vacate_date]
            ,[property_tenancy_health_disability_information_datetime]
            ,[property_tenancy_tenancy_pack_datetime]
            ,[property_tenancy_refund_lodged_date]
            ,[property_tenancy_pay_tenancy_services_by_date]
            ,[property_tenancy_short_term_in_days]
            ,[property_tenancy_bond_reference]
            ,[property_tenancy_tenancy_service_bond_number]
            ,[property_tenancy_tenancy_services_property_identifier]
            ,[property_tenancy_arrears_arrangement_activated]
            ,[property_tenancy_arrears_arrangement_signed]
            ,[property_tenancy_bond_refund_sng_claim_completed]
            ,[property_tenancy_bond_refund_sng_claim_lodged]
            ,[property_tenancy_exit_point]
            ,[property_tenancy_expected_payment_day]
            ,[property_tenancy_expected_payment_frequency]
            ,[property_tenancy_leaving_reason]
            ,[property_tenancy_rent_charged_day]
            ,[property_tenancy_rent_paid_in_advance]
            ,[property_tenancy_inspection_frequency]
            ,[property_tenancy_weeks_bond_requested]
			,[property_tenancy_weekly_rent_payable]
            ,[property_tenancy_manager_name]
            ,[property_tenancy_manager_email]
            ,[property_tenancy_rent]
            ,[property_tenancy_rent_base]
            ,[property_tenancy_primary_tenant_recordbaseid]
			,[property_tenancy_primary_tenant_gender]
			,[primary_contact_ethnicity_name]
			,[property_tenancy_primary_tenant_date_of_birth] 
            ,[property_tenancy_number_signatories]
            ,[property_tenancy_second_client_name]
            ,[property_tenancy_rent_amount_start_date]
            ,[property_tenancy_vacated_date]
			,[property_tenancy_agreement_to_extend_tenancy_received_flag]
            ,[property_tenancy_guidance_on_rent_payment_process_flag]
            ,[property_tenancy_household_composition_correct_flag]
            ,[property_tenancy_household_members_correct_flag]
            ,[property_tenancy_housing_first_flag]
            ,[property_tenancy_ignore_create_void_checklist_flag]
            ,[property_tenancy_ingoing_property_condition_report_flag]
            ,[property_tenancy_ingoing_tenancy_inspection_property_condition_flag]
            ,[property_tenancy_insulation_statement_flag]
            ,[property_tenancy_insurance_statement_flag]
            ,[property_tenancy_invoices_final_charges_to_tenant_added_flag]
            ,[property_tenancy_any_tenant_under_age_18_flag]
            ,[property_tenancy_tenancy_appropriately_housed_flag]
            ,[property_tenancy_keys_handed_over_at_tenancy_signing_flag]
            ,[property_tenancy_lease_agreement_flag]
            ,[property_tenancy_market_renter_flag]
            ,[property_tenancy_msd_notified_to_stop_redirection_flag]
            ,[property_tenancy_msd_referral_letter_received_flag]
            ,[property_tenancy_offboarding_activities_completed_flag]
            ,[property_tenancy_offer_tenant_redirection_water_payment_flag]
            ,[property_tenancy_pcr_signed_flag]
            ,[property_tenancy_pet_authorisation_paperwork_completed_flag]
            ,[property_tenancy_previous_tenancy_finalised_flag]
            ,[property_tenancy_primary_support_needs_entered_flag]
            ,[property_tenancy_health_disability_information_flag]
            ,[property_tenancy_tenancy_pack_flag]
            ,[property_tenancy_risks_entered_flag]
            ,[property_tenancy_routine_inspection_frequency_checkbox_flag]
            ,[property_tenancy_check_next_inspection_date_flag]
            ,[property_tenancy_setup_rent_review_dates_flag]
            ,[property_tenancy_signed_msd_responsibilities_conditions_flag]
            ,[property_tenancy_signed_sng_forms_flag]
            ,[property_tenancy_subsidy_flag]
            ,[property_tenancy_support_people_emergency_contacts_uptodate_flag]
            ,[property_tenancy_contribution_rent_setup_flag]
            ,[property_tenancy_initial_assessment_completed_flag]
            ,[property_tenancy_tenancy_programme_correct_flag]
            ,[property_tenancy_tenancy_started_bos_correct_details_flag]
            ,[property_tenancy_tenant_confirmed_condition_flag]
            ,[property_tenancy_tenant_confirms_ingoing_inventory_list_flag]
            ,[property_tenancy_transfer_flag]
            ,[property_tenancy_understand_sooh_process_flag]
            ,[property_tenancy_vacate_confirmation_flag]
            ,[property_tenancy_household_in_greatest_need_flag]
            ,[property_tenancy_tenant_homeless_flag]
            ,[property_tenancy_water_redirection_started_flag]
            ,[property_tenancy_welcome_visit_complete_flag]
            ,[property_tenancy_created_datetime]
            ,[property_tenancy_modified_datetime]
            ,[property_tenancy_is_delete_flag]
            ,[property_tenant_opportunity_status]
            ,[DWHBatchId]
            ,[DWHEffectiveFrom]
            ,[DWHEffectiveTo]
            ,[DWHIsCurrent]
            ,[DWHSourceSystem]
            ,[DWHDMLOperation]
            )
                    select
                src.[property_tenancy_id] 
				, src.[dim_property_key]
				, src.[dim_gender_key]
				, src.[property_id]
				, src.[ethnicity_id]
				, src.[property_tenancy_tenancy_type] 
				, src.[property_tenancy_owning_business_unit_name] 
				, src.[property_tenancy_tenancy_identifier] 
				, src.[property_tenancy_tenancy_reference] 
				, src.[property_tenancy_tenancy_name]
				, src.[property_tenancy_property_name]
				, src.[property_tenancy_household_name] 
				, src.[property_tenancy_customer_name] 
				, src.[property_tenancy_lease_agreement_datetime] 
				, src.[property_tenancy_tenancy_start_date] 
				, src.[property_tenancy_activate_tenancy_datetime] 
				, src.[property_tenancy_actual_start_date] 
				, src.[property_tenancy_fixed_term_tenancy_end_date] 
				, src.[property_tenancy_short_term_tenancy_end_date] 
				, src.[property_tenancy_expected_vacated_date] 
				, src.[property_tenancy_signed_msd_responsibilities_conditions_datetime] 
				, src.[property_tenancy_signed_sng_forms_datetime] 
				, src.[property_tenancy_actual_close_date] 
				, src.[property_tenancy_bond_lodged_date] 
				, src.[property_tenancy_bond_refund_lodged_date] 
				, src.[property_tenancy_check_bodycorp_or_residents_datetime] 
				, src.[property_tenancy_notice_to_vacate_date] 
				, src.[property_tenancy_health_disability_information_datetime] 
				, src.[property_tenancy_tenancy_pack_datetime] 
				, src.[property_tenancy_refund_lodged_date] 
				, src.[property_tenancy_pay_tenancy_services_by_date] 
				, src.[property_tenancy_short_term_in_days] 
				, src.[property_tenancy_bond_reference] 
				, src.[property_tenancy_tenancy_service_bond_number] 
				, src.[property_tenancy_tenancy_services_property_identifier] 
				, src.[property_tenancy_arrears_arrangement_activated] 
				, src.[property_tenancy_arrears_arrangement_signed] 
				, src.[property_tenancy_bond_refund_sng_claim_completed] 
				, src.[property_tenancy_bond_refund_sng_claim_lodged] 
				, src.[property_tenancy_exit_point] 
				, src.[property_tenancy_expected_payment_day] 
				, src.[property_tenancy_expected_payment_frequency] 
				, src.[property_tenancy_leaving_reason] 
				, src.[property_tenancy_rent_charged_day] 
				, src.[property_tenancy_rent_paid_in_advance] 
				, src.[property_tenancy_inspection_frequency] 
				, src.[property_tenancy_weeks_bond_requested]
				, src.[property_tenancy_weekly_rent_payable]
				, src.[property_tenancy_manager_name] 
				, src.[property_tenancy_manager_email] 
				, src.[property_tenancy_rent] 
				, src.[property_tenancy_rent_base]
				, src.[property_tenancy_primary_tenant_recordbaseid]
				, src.[property_tenancy_primary_tenant_gender]
			    , src.[primary_contact_ethnicity_name]
				, src.[property_tenancy_primary_tenant_date_of_birth] 
				, src.[property_tenancy_number_signatories] 
				, src.[property_tenancy_second_client_name] 
				, src.[property_tenancy_rent_amount_start_date] 
				, src.[property_tenancy_vacated_date]
				, src.[property_tenancy_agreement_to_extend_tenancy_received_flag]
				, src.[property_tenancy_guidance_on_rent_payment_process_flag] 
				, src.[property_tenancy_household_composition_correct_flag] 
				, src.[property_tenancy_household_members_correct_flag] 
				, src.[property_tenancy_housing_first_flag] 
				, src.[property_tenancy_ignore_create_void_checklist_flag] 
				, src.[property_tenancy_ingoing_property_condition_report_flag] 
				, src.[property_tenancy_ingoing_tenancy_inspection_property_condition_flag] 
				, src.[property_tenancy_insulation_statement_flag] 
				, src.[property_tenancy_insurance_statement_flag] 
				, src.[property_tenancy_invoices_final_charges_to_tenant_added_flag] 
				, src.[property_tenancy_any_tenant_under_age_18_flag] 
				, src.[property_tenancy_tenancy_appropriately_housed_flag] 
				, src.[property_tenancy_keys_handed_over_at_tenancy_signing_flag] 
				, src.[property_tenancy_lease_agreement_flag] 
				, src.[property_tenancy_market_renter_flag] 
				, src.[property_tenancy_msd_notified_to_stop_redirection_flag] 
				, src.[property_tenancy_msd_referral_letter_received_flag] 
				, src.[property_tenancy_offboarding_activities_completed_flag] 
				, src.[property_tenancy_offer_tenant_redirection_water_payment_flag] 
				, src.[property_tenancy_pcr_signed_flag] 
				, src.[property_tenancy_pet_authorisation_paperwork_completed_flag] 
				, src.[property_tenancy_previous_tenancy_finalised_flag] 
				, src.[property_tenancy_primary_support_needs_entered_flag] 
				, src.[property_tenancy_health_disability_information_flag] 
				, src.[property_tenancy_tenancy_pack_flag] 
				, src.[property_tenancy_risks_entered_flag] 
				, src.[property_tenancy_routine_inspection_frequency_checkbox_flag] 
				, src.[property_tenancy_check_next_inspection_date_flag] 
				, src.[property_tenancy_setup_rent_review_dates_flag] 
				, src.[property_tenancy_signed_msd_responsibilities_conditions_flag] 
				, src.[property_tenancy_signed_sng_forms_flag] 
				, src.[property_tenancy_subsidy_flag] 
				, src.[property_tenancy_support_people_emergency_contacts_uptodate_flag] 
				, src.[property_tenancy_contribution_rent_setup_flag] 
				, src.[property_tenancy_initial_assessment_completed_flag] 
				, src.[property_tenancy_tenancy_programme_correct_flag] 
				, src.[property_tenancy_tenancy_started_bos_correct_details_flag] 
				, src.[property_tenancy_tenant_confirmed_condition_flag] 
				, src.[property_tenancy_tenant_confirms_ingoing_inventory_list_flag] 
				, src.[property_tenancy_transfer_flag] 
				, src.[property_tenancy_understand_sooh_process_flag] 
				, src.[property_tenancy_vacate_confirmation_flag] 
				, src.[property_tenancy_household_in_greatest_need_flag] 
				, src.[property_tenancy_tenant_homeless_flag] 
				, src.[property_tenancy_water_redirection_started_flag] 
				, src.[property_tenancy_welcome_visit_complete_flag] 
				, src.[property_tenancy_created_datetime] 
				, src.[property_tenancy_modified_datetime] 
				, src.[property_tenancy_is_delete_flag]
				, src.[property_tenant_opportunity_status]
				, @BatchID
				, @SystemEffectiveFrom
				, @SystemDefaultEffectiveTo
				, 1
				, '[Staging].[ODSETLdim_property_tenancy]'
				, 'U'
            from #SummaryOfChanges as base
                inner join [Staging].[ODSETLdim_property_tenancy] as src on src.[property_tenancy_id] = base.[property_tenancy_id]
            where base.[MergeAction] = 'UPDATE'

        union all

            select
                tbl.[property_tenancy_id]
				, tbl.[dim_property_key]
				, tbl.[dim_gender_key]
				, tbl.[property_id]
				, tbl.[ethnicity_id]
				, tbl.[property_tenancy_tenancy_type] 
				, tbl.[property_tenancy_owning_business_unit_name] 
				, tbl.[property_tenancy_tenancy_identifier] 
				, tbl.[property_tenancy_tenancy_reference] 
				, tbl.[property_tenancy_tenancy_name]
				, tbl.[property_tenancy_property_name]
				, tbl.[property_tenancy_household_name] 
				, tbl.[property_tenancy_customer_name] 
				, tbl.[property_tenancy_lease_agreement_datetime] 
				, tbl.[property_tenancy_tenancy_start_date] 
				, tbl.[property_tenancy_activate_tenancy_datetime] 
				, tbl.[property_tenancy_actual_start_date] 
				, tbl.[property_tenancy_fixed_term_tenancy_end_date] 
				, tbl.[property_tenancy_short_term_tenancy_end_date] 
				, tbl.[property_tenancy_expected_vacated_date] 
				, tbl.[property_tenancy_signed_msd_responsibilities_conditions_datetime] 
				, tbl.[property_tenancy_signed_sng_forms_datetime] 
				, tbl.[property_tenancy_actual_close_date] 
				, tbl.[property_tenancy_bond_lodged_date] 
				, tbl.[property_tenancy_bond_refund_lodged_date] 
				, tbl.[property_tenancy_check_bodycorp_or_residents_datetime] 
				, tbl.[property_tenancy_notice_to_vacate_date] 
				, tbl.[property_tenancy_health_disability_information_datetime] 
				, tbl.[property_tenancy_tenancy_pack_datetime] 
				, tbl.[property_tenancy_refund_lodged_date] 
				, tbl.[property_tenancy_pay_tenancy_services_by_date] 
				, tbl.[property_tenancy_short_term_in_days] 
				, tbl.[property_tenancy_bond_reference] 
				, tbl.[property_tenancy_tenancy_service_bond_number] 
				, tbl.[property_tenancy_tenancy_services_property_identifier] 
				, tbl.[property_tenancy_arrears_arrangement_activated] 
				, tbl.[property_tenancy_arrears_arrangement_signed] 
				, tbl.[property_tenancy_bond_refund_sng_claim_completed] 
				, tbl.[property_tenancy_bond_refund_sng_claim_lodged] 
				, tbl.[property_tenancy_exit_point] 
				, tbl.[property_tenancy_expected_payment_day] 
				, tbl.[property_tenancy_expected_payment_frequency] 
				, tbl.[property_tenancy_leaving_reason] 
				, tbl.[property_tenancy_rent_charged_day] 
				, tbl.[property_tenancy_rent_paid_in_advance] 
				, tbl.[property_tenancy_inspection_frequency] 
				, tbl.[property_tenancy_weeks_bond_requested]
				, tbl.[property_tenancy_weekly_rent_payable]
				, tbl.[property_tenancy_manager_name] 
				, tbl.[property_tenancy_manager_email] 
				, tbl.[property_tenancy_rent] 
				, tbl.[property_tenancy_rent_base]
				, tbl.[property_tenancy_primary_tenant_recordbaseid]
				, tbl.[property_tenancy_primary_tenant_gender]
			    , tbl.[primary_contact_ethnicity_name]
				, tbl.[property_tenancy_primary_tenant_date_of_birth] 
				, tbl.[property_tenancy_number_signatories] 
				, tbl.[property_tenancy_second_client_name] 
				, tbl.[property_tenancy_rent_amount_start_date] 
				, tbl.[property_tenancy_vacated_date]
				, tbl.[property_tenancy_agreement_to_extend_tenancy_received_flag]
				, tbl.[property_tenancy_guidance_on_rent_payment_process_flag] 
				, tbl.[property_tenancy_household_composition_correct_flag] 
				, tbl.[property_tenancy_household_members_correct_flag] 
				, tbl.[property_tenancy_housing_first_flag] 
				, tbl.[property_tenancy_ignore_create_void_checklist_flag] 
				, tbl.[property_tenancy_ingoing_property_condition_report_flag] 
				, tbl.[property_tenancy_ingoing_tenancy_inspection_property_condition_flag] 
				, tbl.[property_tenancy_insulation_statement_flag] 
				, tbl.[property_tenancy_insurance_statement_flag] 
				, tbl.[property_tenancy_invoices_final_charges_to_tenant_added_flag] 
				, tbl.[property_tenancy_any_tenant_under_age_18_flag] 
				, tbl.[property_tenancy_tenancy_appropriately_housed_flag] 
				, tbl.[property_tenancy_keys_handed_over_at_tenancy_signing_flag] 
				, tbl.[property_tenancy_lease_agreement_flag] 
				, tbl.[property_tenancy_market_renter_flag] 
				, tbl.[property_tenancy_msd_notified_to_stop_redirection_flag] 
				, tbl.[property_tenancy_msd_referral_letter_received_flag] 
				, tbl.[property_tenancy_offboarding_activities_completed_flag] 
				, tbl.[property_tenancy_offer_tenant_redirection_water_payment_flag] 
				, tbl.[property_tenancy_pcr_signed_flag] 
				, tbl.[property_tenancy_pet_authorisation_paperwork_completed_flag] 
				, tbl.[property_tenancy_previous_tenancy_finalised_flag] 
				, tbl.[property_tenancy_primary_support_needs_entered_flag] 
				, tbl.[property_tenancy_health_disability_information_flag] 
				, tbl.[property_tenancy_tenancy_pack_flag] 
				, tbl.[property_tenancy_risks_entered_flag] 
				, tbl.[property_tenancy_routine_inspection_frequency_checkbox_flag] 
				, tbl.[property_tenancy_check_next_inspection_date_flag] 
				, tbl.[property_tenancy_setup_rent_review_dates_flag] 
				, tbl.[property_tenancy_signed_msd_responsibilities_conditions_flag] 
				, tbl.[property_tenancy_signed_sng_forms_flag] 
				, tbl.[property_tenancy_subsidy_flag] 
				, tbl.[property_tenancy_support_people_emergency_contacts_uptodate_flag] 
				, tbl.[property_tenancy_contribution_rent_setup_flag] 
				, tbl.[property_tenancy_initial_assessment_completed_flag] 
				, tbl.[property_tenancy_tenancy_programme_correct_flag] 
				, tbl.[property_tenancy_tenancy_started_bos_correct_details_flag] 
				, tbl.[property_tenancy_tenant_confirmed_condition_flag] 
				, tbl.[property_tenancy_tenant_confirms_ingoing_inventory_list_flag] 
				, tbl.[property_tenancy_transfer_flag] 
				, tbl.[property_tenancy_understand_sooh_process_flag] 
				, tbl.[property_tenancy_vacate_confirmation_flag] 
				, tbl.[property_tenancy_household_in_greatest_need_flag] 
				, tbl.[property_tenancy_tenant_homeless_flag] 
				, tbl.[property_tenancy_water_redirection_started_flag] 
				, tbl.[property_tenancy_welcome_visit_complete_flag] 
				, tbl.[property_tenancy_created_datetime] 
				, tbl.[property_tenancy_modified_datetime] 
				, tbl.[property_tenancy_is_delete_flag]
				, tbl.[property_tenant_opportunity_status]
				, @BatchID
				, @SystemEffectiveFrom
				, @SystemDefaultEffectiveTo
				, 1
				, '[Staging].[ODSETLdim_property_tenancy]'
				, 'D'
            from #SummaryOfChanges as base
                inner join [edw].[dim_property_tenancy] as tbl on tbl.[property_tenancy_id] = base.[property_tenancy_id] and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
                left join [Staging].[ODSETLdim_property_tenancy] as src on src.[property_tenancy_id] = base.[property_tenancy_id]
            where base.[MergeAction] = 'UPDATE'
                and src.[property_tenancy_id] is null;
    end;

		-- Get process counts
		select
        @targetRecords = count(1) 
			, @insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			, @updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			, @deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
    from [edw].[dim_property_tenancy]
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