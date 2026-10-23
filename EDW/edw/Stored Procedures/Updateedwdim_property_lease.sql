
CREATE procedure [edw].[Updateedwdim_property_lease] 

/**********************************************************************************************************
 Procedure	[edw].[Updateedwdim_property_lease]
 Author		Glenn McLeod
 Created	2023-12-11	
 Purpose		
				
 Notes: Call By	EDW Pipeline '30_Load_From_ODS'
 =========================================================================================================

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2023-12-11	  Glenn McLeod			Initial version
1.1     2025-05-06    Manish Singh			Changed Prefix of Audit columns from EDW to DWH
1.2	    2025-12-09    Greg Nuthall			Added property_id, lease status and lease state
2.0	    2025-02-20    Greg Nuthall			Removed 11 columns per work item 12210
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
as begin

	set nocount on;
	set xact_abort on;

	-- Variables
	declare @batchID int = @pBatchID;
	declare @SourceSystem nvarchar(120) = 'Zavanti.vw_zav_leasedetails';

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
			 [property_lease_details_id] uniqueidentifier null
		,[MergeAction] varchar(10)
	);
	begin transaction;
	begin try
		
		IF (
				NOT EXISTS (
					SELECT 1
					FROM [edw].[dim_property_lease]
					WHERE dim_property_lease_id <= 0
					)
				)
		BEGIN
			-- turn the identity insert on 
			SET IDENTITY_INSERT [edw].[dim_property_lease] ON

			INSERT INTO [edw].[dim_property_lease] (
				dim_property_lease_id
				,property_lease_details_id
				,property_lease_details_name
				,property_lease_details_lease_type_code
				,property_lease_details_contract_name
				,property_lease_details_lease_contract_code
				,property_lease_details_date_lodged
				,property_lease_details_term
				,property_lease_details_term_days
				,property_lease_details_from_date
				,property_lease_details_to_date
				,property_lease_details_bond_comments
				,property_lease_details_bond_total_date
				,property_lease_details_right_of_renewal_years
				,property_lease_details_next_right_of_renewal_date
				,property_lease_details_next_rent_lease_review_date
				,property_lease_details_expected_hand_back_date
				,property_lease_details_legal_owner_name
				,property_lease_details_CORT_signatory_name
				,property_lease_details_property_reference
				,property_lease_details_property_name
				,property_lease_details_property_owner_contact
				,property_lease_details_rent_lease_payment_reference
				,property_lease_details_tenancy_services_reference
				,property_lease_details_agreement_type
				,property_lease_details_frequency
				,property_lease_details_landlord_charge_amount_gst_exclusive
				,property_lease_details_rent_lease_payment_day
				,property_lease_details_crba8_bank_deposit_confirmation_in_sharepoint_flag
				,property_lease_details_landlord_agreement_in_sharepoint_flag
				,property_lease_details_owning_user
				,property_lease_details_property_owner_contact_name
				,property_lease_details_crba8_landlord_annual_charge_amount
				,property_lease_details_new_landlord_lease_charge_amount
				,property_lease_details_bond_amount
				,property_lease_details_bond_total
				,property_lease_details_landlord_monthly_charge_amount
				,property_lease_details_crba8_bank_automatic_payment_number
				,property_lease_details_crba8_last_rent_review_date
				,property_lease_details_deleted_flag
				,synapse_link_sink_modified_on
				,[DWHSourceSystem]
				,[DWHBatchId]
				,[DWHDMLOperation]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				)
			VALUES (
				0
				,NULL
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,'N/A'
				,NULL
				,'N/A'
				,NULL
				,NULL
				,NULL
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,NULL
				,NULL
				,'N/A'
				,'N/A'
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,'N/A'
				,NULL
				,NULL
				,convert(DATETIME, ' 1 January 1900 ')
				,@SourceSystem
				,0
				,'I'
				,convert(DATETIME, ' 1 January 1900 ')
				,@SystemDefaultEffectiveTo
				,1
				)
				,(
				- 1
				,NULL
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,'Unknown'
				,NULL
				,'Unknown'
				,NULL
				,NULL
				,NULL
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,NULL
				,NULL
				,'Unknown'
				,'Unknown'
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,'Unknown'
				,NULL
				,NULL
				,convert(DATETIME, ' 1 January 1900 ')
				,@SourceSystem
				,0
				,'I'
				,convert(DATETIME, ' 1 January 1900 ')
				,@SystemDefaultEffectiveTo
				,1
				)

			-- turn the identity insert off
			SET IDENTITY_INSERT [edw].[dim_property_lease] OFF
		END

		-- Do not run if there are no records in source
		select @stagedRecords = count(1) from [Staging].[ODSETLdim_property_lease];
		if( @stagedRecords = 0 )
		begin
			select 
				 @targetRecords = count(1) 
				,@deletedRecords = sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			from [edw].[dim_property_lease];
			-- Select success details
			select
				 @pErrorRecords = 0
				,@pInsertRecords = 0
				,@pUpdateRecords = 0
				,@pDeleteRecords = 0
				,@pCompleted = 1
				,@pTargetRecords = @targetRecords;	

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

		if( not exists (select top(1) 1 from [edw].[dim_property_lease]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[dim_property_lease]
			(	 [dim_property_key]
				,[property_lease_details_id] 
				,[property_id]
				,[property_lease_status]
				,[property_lease_state]
				,[property_lease_details_name]
				,[property_lease_details_lease_type_code] 
				,[property_lease_details_contract_name] 
				,[property_lease_details_lease_contract_code] 
				,[property_lease_details_date_lodged] 
				,[property_lease_details_term] 
				,[property_lease_details_term_days] 
				,[property_lease_details_from_date] 
				,[property_lease_details_to_date] 
				,[property_lease_details_bond_comments] 
				,[property_lease_details_bond_total_date] 
				,[property_lease_details_right_of_renewal_years] 
				,[property_lease_details_next_right_of_renewal_date] 
				,[property_lease_details_next_rent_lease_review_date] 
				,[property_lease_details_expected_hand_back_date] 
				,[property_lease_details_legal_owner_name] 
				,[property_lease_details_CORT_signatory_name] 
				,[property_lease_details_property_reference] 
				,[property_lease_details_property_name] 
				,[property_lease_details_property_owner_contact] 
				,[property_lease_details_rent_lease_payment_reference] 
				,[property_lease_details_tenancy_services_reference] 
				,[property_lease_details_agreement_type] 
				,[property_lease_details_frequency] 
				,[property_lease_details_landlord_charge_amount_gst_exclusive] 
				,[property_lease_details_rent_lease_payment_day] 
				,[property_lease_details_crba8_bank_deposit_confirmation_in_sharepoint_flag] 
				,[property_lease_details_landlord_agreement_in_sharepoint_flag] 
				,[property_lease_details_owning_user] 
				,[property_lease_details_property_owner_contact_name] 
				,[property_lease_details_crba8_landlord_annual_charge_amount] 
				,[property_lease_details_new_landlord_lease_charge_amount] 
				,[property_lease_details_bond_amount] 
				,[property_lease_details_bond_total] 
				,[property_lease_details_landlord_monthly_charge_amount] 
				,[property_lease_details_crba8_bank_automatic_payment_number] 
				,[property_lease_details_crba8_last_rent_review_date] 
				,[property_lease_details_deleted_flag] 
				,[synapse_link_sink_modified_on] 
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
			)
			select
				src.[dim_property_key]
				,src.[property_lease_details_id] 
				,src.[property_id]
				,src.[property_lease_status]
				,src.[property_lease_state]
				,src.[property_lease_details_name] 
				,src.[property_lease_details_lease_type_code] 
				,src.[property_lease_details_contract_name] 
				,src.[property_lease_details_lease_contract_code] 
				,src.[property_lease_details_date_lodged] 
				,src.[property_lease_details_term] 
				,src.[property_lease_details_term_days] 
				,src.[property_lease_details_from_date] 
				,src.[property_lease_details_to_date] 
				,src.[property_lease_details_bond_comments] 
				,src.[property_lease_details_bond_total_date] 
				,src.[property_lease_details_right_of_renewal_years] 
				,src.[property_lease_details_next_right_of_renewal_date] 
				,src.[property_lease_details_next_rent_lease_review_date] 
				,src.[property_lease_details_expected_hand_back_date] 
				,src.[property_lease_details_legal_owner_name] 
				,src.[property_lease_details_CORT_signatory_name] 
				,src.[property_lease_details_property_reference] 
				,src.[property_lease_details_property_name] 
				,src.[property_lease_details_property_owner_contact] 
				,src.[property_lease_details_rent_lease_payment_reference] 
				,src.[property_lease_details_tenancy_services_reference] 
				,src.[property_lease_details_agreement_type] 
				,src.[property_lease_details_frequency] 
				,src.[property_lease_details_landlord_charge_amount_gst_exclusive] 
				,src.[property_lease_details_rent_lease_payment_day] 
				,src.[property_lease_details_crba8_bank_deposit_confirmation_in_sharepoint_flag] 
				,src.[property_lease_details_landlord_agreement_in_sharepoint_flag] 
				,src.[property_lease_details_owning_user] 
				,src.[property_lease_details_property_owner_contact_name] 
				,src.[property_lease_details_crba8_landlord_annual_charge_amount] 
				,src.[property_lease_details_new_landlord_lease_charge_amount] 
				,src.[property_lease_details_bond_amount] 
				,src.[property_lease_details_bond_total] 
				,src.[property_lease_details_landlord_monthly_charge_amount] 
				,src.[property_lease_details_crba8_bank_automatic_payment_number] 
				,src.[property_lease_details_crba8_last_rent_review_date] 
				,src.[property_lease_details_deleted_flag] 
				,src.[synapse_link_sink_modified_on] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLdim_property_lease] as src;
		end else begin
			-- Fetch the current high-water maximum values
			declare @synapse_link_sink_modified_on datetime2(7) = null;

			execute [edw].[GetHighwaterForedwdim_property_lease] @synapse_link_sink_modified_on output;

			merge into [edw].[dim_property_lease] as trg
			using 
			(
				select
				 src.[dim_property_key]
				,src.[property_lease_details_id] 
				,src.[property_id]
				,src.[property_lease_status]
				,src.[property_lease_state]
				,src.[property_lease_details_name] 
				,src.[property_lease_details_lease_type_code] 
				,src.[property_lease_details_contract_name] 
				,src.[property_lease_details_lease_contract_code] 
				,src.[property_lease_details_date_lodged] 
				,src.[property_lease_details_term] 
				,src.[property_lease_details_term_days] 
				,src.[property_lease_details_from_date] 
				,src.[property_lease_details_to_date] 
				,src.[property_lease_details_bond_comments] 
				,src.[property_lease_details_bond_total_date] 
				,src.[property_lease_details_right_of_renewal_years] 
				,src.[property_lease_details_next_right_of_renewal_date] 
				,src.[property_lease_details_next_rent_lease_review_date] 
				,src.[property_lease_details_expected_hand_back_date] 
				,src.[property_lease_details_legal_owner_name] 
				,src.[property_lease_details_CORT_signatory_name] 
				,src.[property_lease_details_property_reference] 
				,src.[property_lease_details_property_name] 
				,src.[property_lease_details_property_owner_contact] 
				,src.[property_lease_details_rent_lease_payment_reference] 
				,src.[property_lease_details_tenancy_services_reference] 
				,src.[property_lease_details_agreement_type] 
				,src.[property_lease_details_frequency] 
				,src.[property_lease_details_landlord_charge_amount_gst_exclusive] 
				,src.[property_lease_details_rent_lease_payment_day] 
				,src.[property_lease_details_crba8_bank_deposit_confirmation_in_sharepoint_flag] 
				,src.[property_lease_details_landlord_agreement_in_sharepoint_flag] 
				,src.[property_lease_details_owning_user] 
				,src.[property_lease_details_property_owner_contact_name] 
				,src.[property_lease_details_crba8_landlord_annual_charge_amount] 
				,src.[property_lease_details_new_landlord_lease_charge_amount] 
				,src.[property_lease_details_bond_amount] 
				,src.[property_lease_details_bond_total] 
				,src.[property_lease_details_landlord_monthly_charge_amount] 
				,src.[property_lease_details_crba8_bank_automatic_payment_number] 
				,src.[property_lease_details_crba8_last_rent_review_date] 
				,src.[property_lease_details_deleted_flag] 
				,src.[synapse_link_sink_modified_on] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLdim_property_lease] as src
			) as src on (src.[property_lease_details_id] = trg.[property_lease_details_id] and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
				select src.[property_lease_details_name],src.[property_id],src.[property_lease_status],src.[property_lease_state] , src.[property_lease_details_lease_type_code], src.[property_lease_details_contract_name], src.[property_lease_details_lease_contract_code], src.[property_lease_details_date_lodged], src.[property_lease_details_term], src.[property_lease_details_term_days], src.[property_lease_details_from_date], src.[property_lease_details_to_date], src.[property_lease_details_bond_comments], src.[property_lease_details_bond_total_date], src.[property_lease_details_right_of_renewal_years], src.[property_lease_details_next_right_of_renewal_date], src.[property_lease_details_next_rent_lease_review_date], src.[property_lease_details_expected_hand_back_date], src.[property_lease_details_legal_owner_name], src.[property_lease_details_CORT_signatory_name], src.[property_lease_details_property_reference], src.[property_lease_details_property_name], src.[property_lease_details_property_owner_contact], src.[property_lease_details_rent_lease_payment_reference], src.[property_lease_details_tenancy_services_reference], src.[property_lease_details_agreement_type], src.[property_lease_details_frequency], src.[property_lease_details_landlord_charge_amount_gst_exclusive], src.[property_lease_details_rent_lease_payment_day], src.[property_lease_details_crba8_bank_deposit_confirmation_in_sharepoint_flag], src.[property_lease_details_landlord_agreement_in_sharepoint_flag], src.[property_lease_details_owning_user], src.[property_lease_details_property_owner_contact_name], src.[property_lease_details_crba8_landlord_annual_charge_amount], src.[property_lease_details_new_landlord_lease_charge_amount], src.[property_lease_details_bond_amount], src.[property_lease_details_bond_total], src.[property_lease_details_landlord_monthly_charge_amount], src.[property_lease_details_crba8_bank_automatic_payment_number], src.[property_lease_details_crba8_last_rent_review_date], src.[property_lease_details_deleted_flag], src.[synapse_link_sink_modified_on], case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
				except
				select trg.[property_lease_details_name],trg.[property_id],trg.[property_lease_status],trg.[property_lease_state] , trg.[property_lease_details_lease_type_code], trg.[property_lease_details_contract_name], trg.[property_lease_details_lease_contract_code], trg.[property_lease_details_date_lodged], trg.[property_lease_details_term], trg.[property_lease_details_term_days], trg.[property_lease_details_from_date], trg.[property_lease_details_to_date], trg.[property_lease_details_bond_comments], trg.[property_lease_details_bond_total_date], trg.[property_lease_details_right_of_renewal_years], trg.[property_lease_details_next_right_of_renewal_date], trg.[property_lease_details_next_rent_lease_review_date], trg.[property_lease_details_expected_hand_back_date], trg.[property_lease_details_legal_owner_name], trg.[property_lease_details_CORT_signatory_name], trg.[property_lease_details_property_reference], trg.[property_lease_details_property_name], trg.[property_lease_details_property_owner_contact], trg.[property_lease_details_rent_lease_payment_reference], trg.[property_lease_details_tenancy_services_reference], trg.[property_lease_details_agreement_type], trg.[property_lease_details_frequency], trg.[property_lease_details_landlord_charge_amount_gst_exclusive], trg.[property_lease_details_rent_lease_payment_day], trg.[property_lease_details_crba8_bank_deposit_confirmation_in_sharepoint_flag], trg.[property_lease_details_landlord_agreement_in_sharepoint_flag], trg.[property_lease_details_owning_user], trg.[property_lease_details_property_owner_contact_name], trg.[property_lease_details_crba8_landlord_annual_charge_amount], trg.[property_lease_details_new_landlord_lease_charge_amount], trg.[property_lease_details_bond_amount], trg.[property_lease_details_bond_total], trg.[property_lease_details_landlord_monthly_charge_amount], trg.[property_lease_details_crba8_bank_automatic_payment_number], trg.[property_lease_details_crba8_last_rent_review_date], trg.[property_lease_details_deleted_flag], trg.[synapse_link_sink_modified_on], 'X'
			) then  
				update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0

			-- Soft delete missing records
			when not matched by source 
			and trg.dim_property_lease_id > 0
			and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo 
			and trg.[DWHDMLOperation] <> 'D' 
			and trg.[synapse_link_sink_modified_on] > @synapse_link_sink_modified_on then 
				update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0

			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [dim_property_key]
					,[property_lease_details_id] 
					,[property_id]
					,[property_lease_status]
					,[property_lease_state]
					,[property_lease_details_name] 
					,[property_lease_details_lease_type_code] 
					,[property_lease_details_contract_name] 
					,[property_lease_details_lease_contract_code] 
					,[property_lease_details_date_lodged] 
					,[property_lease_details_term] 
					,[property_lease_details_term_days] 
					,[property_lease_details_from_date] 
					,[property_lease_details_to_date] 
					,[property_lease_details_bond_comments] 
					,[property_lease_details_bond_total_date] 
					,[property_lease_details_right_of_renewal_years] 
					,[property_lease_details_next_right_of_renewal_date] 
					,[property_lease_details_next_rent_lease_review_date] 
					,[property_lease_details_expected_hand_back_date] 
					,[property_lease_details_legal_owner_name] 
					,[property_lease_details_CORT_signatory_name] 
					,[property_lease_details_property_reference] 
					,[property_lease_details_property_name] 
					,[property_lease_details_property_owner_contact] 
					,[property_lease_details_rent_lease_payment_reference] 
					,[property_lease_details_tenancy_services_reference] 
					,[property_lease_details_agreement_type] 
					,[property_lease_details_frequency] 
					,[property_lease_details_landlord_charge_amount_gst_exclusive] 
					,[property_lease_details_rent_lease_payment_day] 
					,[property_lease_details_crba8_bank_deposit_confirmation_in_sharepoint_flag] 
					,[property_lease_details_landlord_agreement_in_sharepoint_flag] 
					,[property_lease_details_owning_user] 
					,[property_lease_details_property_owner_contact_name] 
					,[property_lease_details_crba8_landlord_annual_charge_amount] 
					,[property_lease_details_new_landlord_lease_charge_amount] 
					,[property_lease_details_bond_amount] 
					,[property_lease_details_bond_total] 
					,[property_lease_details_landlord_monthly_charge_amount] 
					,[property_lease_details_crba8_bank_automatic_payment_number] 
					,[property_lease_details_crba8_last_rent_review_date] 
					,[property_lease_details_deleted_flag] 
					,[synapse_link_sink_modified_on] 
					,[DWHBatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperation] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[dim_property_key]
					,src.[property_lease_details_id] 
					,src.[property_id]
					,src.[property_lease_status]
					,src.[property_lease_state]
					,src.[property_lease_details_name] 
					,src.[property_lease_details_lease_type_code] 
					,src.[property_lease_details_contract_name] 
					,src.[property_lease_details_lease_contract_code] 
					,src.[property_lease_details_date_lodged] 
					,src.[property_lease_details_term] 
					,src.[property_lease_details_term_days] 
					,src.[property_lease_details_from_date] 
					,src.[property_lease_details_to_date] 
					,src.[property_lease_details_bond_comments] 
					,src.[property_lease_details_bond_total_date] 
					,src.[property_lease_details_right_of_renewal_years] 
					,src.[property_lease_details_next_right_of_renewal_date] 
					,src.[property_lease_details_next_rent_lease_review_date] 
					,src.[property_lease_details_expected_hand_back_date] 
					,src.[property_lease_details_legal_owner_name] 
					,src.[property_lease_details_CORT_signatory_name] 
					,src.[property_lease_details_property_reference] 
					,src.[property_lease_details_property_name] 
					,src.[property_lease_details_property_owner_contact] 
					,src.[property_lease_details_rent_lease_payment_reference] 
					,src.[property_lease_details_tenancy_services_reference] 
					,src.[property_lease_details_agreement_type] 
					,src.[property_lease_details_frequency] 
					,src.[property_lease_details_landlord_charge_amount_gst_exclusive] 
					,src.[property_lease_details_rent_lease_payment_day] 
					,src.[property_lease_details_crba8_bank_deposit_confirmation_in_sharepoint_flag] 
					,src.[property_lease_details_landlord_agreement_in_sharepoint_flag] 
					,src.[property_lease_details_owning_user] 
					,src.[property_lease_details_property_owner_contact_name] 
					,src.[property_lease_details_crba8_landlord_annual_charge_amount] 
					,src.[property_lease_details_new_landlord_lease_charge_amount] 
					,src.[property_lease_details_bond_amount] 
					,src.[property_lease_details_bond_total] 
					,src.[property_lease_details_landlord_monthly_charge_amount] 
					,src.[property_lease_details_crba8_bank_automatic_payment_number] 
					,src.[property_lease_details_crba8_last_rent_review_date] 
					,src.[property_lease_details_deleted_flag] 
					,src.[synapse_link_sink_modified_on] 
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[property_lease_details_id],inserted.[property_lease_details_id]), $action As [MergeAction] into #SummaryOfChanges;
		
			-- Insert new versions of previously updated records (Updates and Deletes)
			insert into [edw].[dim_property_lease]
			(
				 [dim_property_key]
				,[property_lease_details_id] 
				,[property_id]
				,[property_lease_status]
				,[property_lease_state]
				,[property_lease_details_name] 
				,[property_lease_details_lease_type_code] 
				,[property_lease_details_contract_name] 
				,[property_lease_details_lease_contract_code] 
				,[property_lease_details_date_lodged] 
				,[property_lease_details_term] 
				,[property_lease_details_term_days] 
				,[property_lease_details_from_date] 
				,[property_lease_details_to_date] 
				,[property_lease_details_bond_comments] 
				,[property_lease_details_bond_total_date] 
				,[property_lease_details_right_of_renewal_years] 
				,[property_lease_details_next_right_of_renewal_date] 
				,[property_lease_details_next_rent_lease_review_date] 
				,[property_lease_details_expected_hand_back_date] 
				,[property_lease_details_legal_owner_name] 
				,[property_lease_details_CORT_signatory_name] 
				,[property_lease_details_property_reference] 
				,[property_lease_details_property_name] 
				,[property_lease_details_property_owner_contact] 
				,[property_lease_details_rent_lease_payment_reference] 
				,[property_lease_details_tenancy_services_reference] 
				,[property_lease_details_agreement_type] 
				,[property_lease_details_frequency] 
				,[property_lease_details_landlord_charge_amount_gst_exclusive] 
				,[property_lease_details_rent_lease_payment_day] 
				,[property_lease_details_crba8_bank_deposit_confirmation_in_sharepoint_flag] 
				,[property_lease_details_landlord_agreement_in_sharepoint_flag] 
				,[property_lease_details_owning_user] 
				,[property_lease_details_property_owner_contact_name] 
				,[property_lease_details_crba8_landlord_annual_charge_amount] 
				,[property_lease_details_new_landlord_lease_charge_amount] 
				,[property_lease_details_bond_amount] 
				,[property_lease_details_bond_total] 
				,[property_lease_details_landlord_monthly_charge_amount] 
				,[property_lease_details_crba8_bank_automatic_payment_number] 
				,[property_lease_details_crba8_last_rent_review_date] 
				,[property_lease_details_deleted_flag] 
				,[synapse_link_sink_modified_on] 
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
			)
			select
				 src.[dim_property_key]
				,src.[property_lease_details_id] 
				,src.[property_id]
				,src.[property_lease_status]
				,src.[property_lease_state]
				,src.[property_lease_details_name] 
				,src.[property_lease_details_lease_type_code] 
				,src.[property_lease_details_contract_name] 
				,src.[property_lease_details_lease_contract_code] 
				,src.[property_lease_details_date_lodged] 
				,src.[property_lease_details_term] 
				,src.[property_lease_details_term_days] 
				,src.[property_lease_details_from_date] 
				,src.[property_lease_details_to_date] 
				,src.[property_lease_details_bond_comments] 
				,src.[property_lease_details_bond_total_date] 
				,src.[property_lease_details_right_of_renewal_years] 
				,src.[property_lease_details_next_right_of_renewal_date] 
				,src.[property_lease_details_next_rent_lease_review_date] 
				,src.[property_lease_details_expected_hand_back_date] 
				,src.[property_lease_details_legal_owner_name] 
				,src.[property_lease_details_CORT_signatory_name] 
				,src.[property_lease_details_property_reference] 
				,src.[property_lease_details_property_name] 
				,src.[property_lease_details_property_owner_contact] 
				,src.[property_lease_details_rent_lease_payment_reference] 
				,src.[property_lease_details_tenancy_services_reference] 
				,src.[property_lease_details_agreement_type] 
				,src.[property_lease_details_frequency] 
				,src.[property_lease_details_landlord_charge_amount_gst_exclusive] 
				,src.[property_lease_details_rent_lease_payment_day] 
				,src.[property_lease_details_crba8_bank_deposit_confirmation_in_sharepoint_flag] 
				,src.[property_lease_details_landlord_agreement_in_sharepoint_flag] 
				,src.[property_lease_details_owning_user] 
				,src.[property_lease_details_property_owner_contact_name] 
				,src.[property_lease_details_crba8_landlord_annual_charge_amount] 
				,src.[property_lease_details_new_landlord_lease_charge_amount] 
				,src.[property_lease_details_bond_amount] 
				,src.[property_lease_details_bond_total] 
				,src.[property_lease_details_landlord_monthly_charge_amount] 
				,src.[property_lease_details_crba8_bank_automatic_payment_number] 
				,src.[property_lease_details_crba8_last_rent_review_date] 
				,src.[property_lease_details_deleted_flag] 
				,src.[synapse_link_sink_modified_on] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'Zavanti.vw_zav_leasedetails'
				,'U'
			from #SummaryOfChanges as base
			inner join [Staging].[ODSETLdim_property_lease] as src on src.[property_lease_details_id] = base.[property_lease_details_id]
			where base.[MergeAction] = 'UPDATE'

			union all 

			select
				 tbl.[dim_property_key]
				,tbl.[property_lease_details_id] 
				,tbl.[property_id]
				,tbl.[property_lease_status]
				,tbl.[property_lease_state]
				,tbl.[property_lease_details_name] 
				,tbl.[property_lease_details_lease_type_code] 
				,tbl.[property_lease_details_contract_name] 
				,tbl.[property_lease_details_lease_contract_code] 
				,tbl.[property_lease_details_date_lodged] 
				,tbl.[property_lease_details_term] 
				,tbl.[property_lease_details_term_days] 
				,tbl.[property_lease_details_from_date] 
				,tbl.[property_lease_details_to_date] 
				,tbl.[property_lease_details_bond_comments] 
				,tbl.[property_lease_details_bond_total_date] 
				,tbl.[property_lease_details_right_of_renewal_years] 
				,tbl.[property_lease_details_next_right_of_renewal_date] 
				,tbl.[property_lease_details_next_rent_lease_review_date] 
				,tbl.[property_lease_details_expected_hand_back_date] 
				,tbl.[property_lease_details_legal_owner_name] 
				,tbl.[property_lease_details_CORT_signatory_name] 
				,tbl.[property_lease_details_property_reference] 
				,tbl.[property_lease_details_property_name] 
				,tbl.[property_lease_details_property_owner_contact] 
				,tbl.[property_lease_details_rent_lease_payment_reference] 
				,tbl.[property_lease_details_tenancy_services_reference] 
				,tbl.[property_lease_details_agreement_type] 
				,tbl.[property_lease_details_frequency] 
				,tbl.[property_lease_details_landlord_charge_amount_gst_exclusive] 
				,tbl.[property_lease_details_rent_lease_payment_day] 
				,tbl.[property_lease_details_crba8_bank_deposit_confirmation_in_sharepoint_flag] 
				,tbl.[property_lease_details_landlord_agreement_in_sharepoint_flag] 
				,tbl.[property_lease_details_owning_user] 
				,tbl.[property_lease_details_property_owner_contact_name] 
				,tbl.[property_lease_details_crba8_landlord_annual_charge_amount] 
				,tbl.[property_lease_details_new_landlord_lease_charge_amount] 
				,tbl.[property_lease_details_bond_amount] 
				,tbl.[property_lease_details_bond_total] 
				,tbl.[property_lease_details_landlord_monthly_charge_amount] 
				,tbl.[property_lease_details_crba8_bank_automatic_payment_number] 
				,tbl.[property_lease_details_crba8_last_rent_review_date] 
				,tbl.[property_lease_details_deleted_flag] 
				,tbl.[synapse_link_sink_modified_on] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'Zavanti.vw_zav_leasedetails'
				,'D'
			from #SummaryOfChanges as base
			inner join [edw].[dim_property_lease] as tbl on tbl.[property_lease_details_id] = base.[property_lease_details_id] and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			left join [Staging].[ODSETLdim_property_lease] as src on src.[property_lease_details_id] = base.[property_lease_details_id]
			where base.[MergeAction] = 'UPDATE'
			and  src.[property_lease_details_id] is null;
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[dim_property_lease]
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