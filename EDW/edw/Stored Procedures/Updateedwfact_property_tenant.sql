
CREATE procedure [edw].[Updateedwfact_property_tenant]

	/**********************************************************************************************************
 Procedure	[edw].[Updateedwfact_property_tenant]
 Author		TMK Team
 Created	2024-01-01
 Purpose	Updates fact_property_tenant table with property tenant data from staging
 Notes: 		Called from ETL process with @pBatchID parameter
 =========================================================================================================
 REVISIONS:
 Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
 1.0		 2024-01-01   TMK Team		Initial creation
 1.1		 2025-02-20   Greg Nuthall	Removed 7 columns per work item 12210
 1.2         2026-06-16   Greg Nuthall	Added 3 new flags
 1.5         2026-07-28   Mike Gencic   Ethnicity + 3 flags on main-applicant HOUSE rows via zav_fullname identity join 
										and household_zavanti_status, household_amendment_date added
**********************************************************************************************************/


	@pBatchID int,
	@pIndexRebuildThreshold int,
	@pOutputParamsAsDataset int = 0,
	@pErrorRecords int = null OUTPUT,
	@pInsertRecords int = null OUTPUT,
	@pUpdateRecords int = null OUTPUT,
	@pDeleteRecords int = null OUTPUT,
	@pCompleted int = null OUTPUT,
	@pTargetRecords int = null OUTPUT
as
begin

	set nocount on;
	set xact_abort on;

	-- Variables
	declare @batchID int = @pBatchID;
	declare @SourceSystem nvarchar(120) = 'zavanti.vw_opportunity, vw_zav_household, vw_zav_house';

	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;

	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;

	declare @systemCurrentDate datetime = getdate();

	-- Do not run if there are records in source
	select @stagedRecords = count(1)
	from [Staging].[ODSETLfact_property_tenant];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1)
		from [edw].[fact_property_tenant];

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
				@targetRecords	as TargetRecords;
		end;

		return;
	end;

	begin transaction;

	begin try
		if( not exists (select top(1)
		1
	from [edw].[fact_property_tenant]) )
		begin
		-- There are no records in the target; insert all
		insert into [edw].[fact_property_tenant]
			(dim_property_key
			,dim_property_tenancy_key
			,dim_property_program_key
			,[property_tenancy_id]
			,[property_tenant_id]
			,[property_id]
			,[property_program_id]
			,[property_subprogram_id]
			,[property_tenancy_total_rent_amount]
			,[property_tenant_tenancy_lease_agreement_date_id]
			,[property_tenant_tenancy_start_date_id]
			,[property_tenant_first_name]
			,[property_tenant_last_name]
			,[property_tenant_full_name]
			,[property_tenancy_tenant_date_of_birth]
			,[property_tenant_registration_date]
			,[property_tenant_client_identifier]
			,[property_tenant_head_of_household_flag]
			,[occupant_record_source]
			,[occupant_statecode]
			,[occupant_statuscode]
			,[property_tenant_tenancy_name]
			,[property_tenant_household_name]
			,[property_tenancy_household_identifier]
			,[property_tenant_number_of_household_members]
			,[property_tenant_named_household_members]
			,[property_tenant_rent_share_total]
			,[property_tenant_total_household_income]
			,[property_tenant_ethnicity_name]
			,[property_tenant_household_zavanti_status]
			,[property_tenant_household_amendment_date]
			,[occupant_is_main_applicant_flag]
			,[property_tenant_created_datetime]
			,[property_tenant_modified_datetime]
			,[occupant_gender_label]
			,[occupant_disability_label]
			,[occupant_targetgroup_label]
			,[occupant_employment_label]
			,[occupant_contacttype_label]
			,[occupant_eatargetgroup_label]
			,[occupant_state_label]
			,[occupant_status_label]
			,[household_state_label]
			,[household_status_label]
			,[property_tenant_opportunity_state]
			,[property_tenant_opportunity_status]
			,[occupant_emergency_contact_flag]
			,[occupant_iwi_affiliation_flag]
			,[occupant_social_works_number_flag]
			,[property_tenant_is_delete_flag]
			,[DWHBatchId]
			,[DWHCreatedAt]
			,[DWHModifiedOn]
			,[DWHDMLOperation]
			,[DWHSourceSystem]
			)
		select
			src.dim_property_key
				, src.dim_property_tenancy_key
				, src.dim_property_program_key
				, src.[property_tenancy_id] 
				, src.[property_tenant_id] 
				, src.[property_id] 
				, src.[property_program_id] 
				, src.[property_subprogram_id] 
				, src.[property_tenancy_total_rent_amount] 
				, src.[property_tenant_tenancy_lease_agreement_date_id] 
				, src.[property_tenant_tenancy_start_date_id] 
				, src.[property_tenant_first_name] 
				, src.[property_tenant_last_name] 
				, src.[property_tenant_full_name] 
				, src.[property_tenancy_tenant_date_of_birth] 
				, src.[property_tenant_registration_date] 
				, src.[property_tenant_client_identifier] 
				, src.[property_tenant_head_of_household_flag] 
				, src.[occupant_record_source] 
				, src.[occupant_statecode] 
				, src.[occupant_statuscode] 
				, src.[property_tenant_tenancy_name] 
				, src.[property_tenant_household_name] 
				, src.[property_tenancy_household_identifier] 
				, src.[property_tenant_number_of_household_members] 
				, src.[property_tenant_named_household_members] 
				, src.[property_tenant_rent_share_total] 
				, src.[property_tenant_total_household_income]
				, src.[property_tenant_ethnicity_name]
				, src.[property_tenant_household_zavanti_status]
				, src.[property_tenant_household_amendment_date]
				, src.[occupant_is_main_applicant_flag]
				, src.[property_tenant_created_datetime] 
				, src.[property_tenant_modified_datetime] 
				, src.[occupant_gender_label] 
				, src.[occupant_disability_label] 
				, src.[occupant_targetgroup_label] 
				, src.[occupant_employment_label] 
				, src.[occupant_contacttype_label]
				, src.[occupant_eatargetgroup_label]
				, src.[occupant_state_label] 
				, src.[occupant_status_label] 
				, src.[household_state_label] 
				, src.[household_status_label] 
				, src.[property_tenant_opportunity_state] 
				, src.[property_tenant_opportunity_status]
				, src.[occupant_emergency_contact_flag]
				, src.[occupant_iwi_affiliation_flag]
				, src.[occupant_social_works_number_flag]
				, src.[property_tenant_is_delete_flag]
				, @BatchID as [DWHBatchId]
				, getdate() as [DWHCreatedAt]
				, getdate() as [DWHModifiedOn]
				, 'I' as [DWHDMLOperation]
				, @SourceSystem as [DWHSourceSystem]
		from [Staging].[ODSETLfact_property_tenant] as src;
	end else begin
		merge into [edw].[fact_property_tenant] as trg
			using 
			(
				select
			src.dim_property_key
				, src.dim_property_tenancy_key
				, src.dim_property_program_key
				, src.[property_tenancy_id] 
				, src.[property_tenant_id] 
				, src.[property_id] 
				, src.[property_program_id] 
				, src.[property_subprogram_id] 
				, src.[property_tenancy_total_rent_amount] 
				, src.[property_tenant_tenancy_lease_agreement_date_id] 
				, src.[property_tenant_tenancy_start_date_id] 
				, src.[property_tenant_first_name] 
				, src.[property_tenant_last_name] 
				, src.[property_tenant_full_name] 
				, src.[property_tenancy_tenant_date_of_birth] 
				, src.[property_tenant_registration_date] 
				, src.[property_tenant_client_identifier] 
				, src.[property_tenant_head_of_household_flag] 
				, src.[occupant_record_source] 
				, src.[occupant_statecode] 
				, src.[occupant_statuscode] 
				, src.[property_tenant_tenancy_name] 
				, src.[property_tenant_household_name] 
				, src.[property_tenancy_household_identifier] 
				, src.[property_tenant_number_of_household_members] 
				, src.[property_tenant_named_household_members] 
				, src.[property_tenant_rent_share_total] 
				, src.[property_tenant_total_household_income]
				, src.[property_tenant_ethnicity_name]
				, src.[property_tenant_household_zavanti_status]
				, src.[property_tenant_household_amendment_date]
				, src.[occupant_is_main_applicant_flag]
				, src.[property_tenant_created_datetime] 
				, src.[property_tenant_modified_datetime] 
				, src.[occupant_gender_label] 
				, src.[occupant_disability_label] 
				, src.[occupant_targetgroup_label] 
				, src.[occupant_employment_label] 
				, src.[occupant_contacttype_label]
				, src.[occupant_eatargetgroup_label]
				, src.[occupant_state_label] 
				, src.[occupant_status_label] 
				, src.[household_state_label] 
				, src.[household_status_label] 
				, src.[property_tenant_opportunity_state] 
				, src.[property_tenant_opportunity_status]
				, src.[occupant_emergency_contact_flag]
				, src.[occupant_iwi_affiliation_flag]
				, src.[occupant_social_works_number_flag]
				, src.[property_tenant_is_delete_flag]
				, @BatchID as [DWHBatchId]
				, getdate() as [DWHCreatedAt]
				, getdate() as [DWHModifiedOn]
				, 'I' as [DWHDMLOperation]
				, @SourceSystem as [DWHSourceSystem]
		from [Staging].[ODSETLfact_property_tenant] as src
			) as src on (src.[property_tenancy_id] = trg.[property_tenancy_id] and src.[property_tenant_id] = trg.[property_tenant_id] collate database_default)			-- Retire existing records
			when matched and exists 
			( 
				select src.[property_id], src.[property_program_id], src.[property_subprogram_id], src.[property_tenancy_total_rent_amount], src.[property_tenant_tenancy_lease_agreement_date_id], src.[property_tenant_tenancy_start_date_id], src.[property_tenant_first_name], src.[property_tenant_last_name], src.[property_tenant_full_name], src.[property_tenancy_tenant_date_of_birth], src.[property_tenant_registration_date], src.[property_tenant_client_identifier], src.[property_tenant_head_of_household_flag], src.[occupant_record_source], src.[occupant_statecode], src.[occupant_statuscode], src.[property_tenant_tenancy_name], src.[property_tenant_household_name], src.[property_tenancy_household_identifier], src.[property_tenant_number_of_household_members], src.[property_tenant_named_household_members], src.[property_tenant_rent_share_total], src.[property_tenant_total_household_income], src.[property_tenant_ethnicity_name], src.[property_tenant_household_zavanti_status], src.[property_tenant_household_amendment_date],  src.[occupant_is_main_applicant_flag], src.[property_tenant_created_datetime], src.[property_tenant_modified_datetime], src.[occupant_gender_label], src.[occupant_disability_label], src.[occupant_targetgroup_label], src.[occupant_employment_label], src.[occupant_contacttype_label], src.[occupant_eatargetgroup_label], src.[occupant_state_label], src.[occupant_status_label], src.[household_state_label], src.[household_status_label], src.[property_tenant_opportunity_state], src.[property_tenant_opportunity_status], isnull(src.occupant_emergency_contact_flag,0), isnull(src.occupant_iwi_affiliation_flag,0) , isnull(src.occupant_social_works_number_flag,0),  isnull(src.[property_tenant_is_delete_flag],0)
			except
				select trg.[property_id], trg.[property_program_id], trg.[property_subprogram_id], trg.[property_tenancy_total_rent_amount], trg.[property_tenant_tenancy_lease_agreement_date_id], trg.[property_tenant_tenancy_start_date_id], trg.[property_tenant_first_name], trg.[property_tenant_last_name], trg.[property_tenant_full_name], trg.[property_tenancy_tenant_date_of_birth], trg.[property_tenant_registration_date], trg.[property_tenant_client_identifier], trg.[property_tenant_head_of_household_flag], trg.[occupant_record_source], trg.[occupant_statecode], trg.[occupant_statuscode], trg.[property_tenant_tenancy_name], trg.[property_tenant_household_name], trg.[property_tenancy_household_identifier], trg.[property_tenant_number_of_household_members], trg.[property_tenant_named_household_members], trg.[property_tenant_rent_share_total], trg.[property_tenant_total_household_income], trg.[property_tenant_ethnicity_name], trg.[property_tenant_household_zavanti_status], trg.[property_tenant_household_amendment_date],  trg.[occupant_is_main_applicant_flag], trg.[property_tenant_created_datetime], trg.[property_tenant_modified_datetime], trg.[occupant_gender_label], trg.[occupant_disability_label], trg.[occupant_targetgroup_label], trg.[occupant_employment_label], trg.[occupant_contacttype_label], trg.[occupant_eatargetgroup_label], trg.[occupant_state_label], trg.[occupant_status_label], trg.[household_state_label], trg.[household_status_label], trg.[property_tenant_opportunity_state], trg.[property_tenant_opportunity_status], isnull(trg.occupant_emergency_contact_flag,0), isnull(trg.occupant_iwi_affiliation_flag,0) , isnull(trg.occupant_social_works_number_flag,0),  isnull(trg.[property_tenant_is_delete_flag],0)
			) then  update set 
				  dim_property_key = src.dim_property_key
				, dim_property_tenancy_key = src.dim_property_tenancy_key
				, dim_property_program_key = src.dim_property_program_key
				, [property_tenancy_id] = src.[property_tenancy_id]
				, [property_tenant_id] = src.[property_tenant_id]
				, [property_id] = src.[property_id]
				, [property_program_id] = src.[property_program_id]
				, [property_subprogram_id] = src.[property_subprogram_id]
				, [property_tenancy_total_rent_amount] = src.[property_tenancy_total_rent_amount]
				, [property_tenant_tenancy_lease_agreement_date_id] = src.[property_tenant_tenancy_lease_agreement_date_id]
				, [property_tenant_tenancy_start_date_id] = src.[property_tenant_tenancy_start_date_id]
				, [property_tenant_first_name] = src.[property_tenant_first_name]
				, [property_tenant_last_name] = src.[property_tenant_last_name]
				, [property_tenant_full_name] = src.[property_tenant_full_name]
				, [property_tenancy_tenant_date_of_birth] = src.[property_tenancy_tenant_date_of_birth]
				, [property_tenant_registration_date] = src.[property_tenant_registration_date]
				, [property_tenant_client_identifier] = src.[property_tenant_client_identifier]
				, [property_tenant_head_of_household_flag] = src.[property_tenant_head_of_household_flag]
				, [occupant_record_source] = src.[occupant_record_source]
				, [occupant_statecode] = src.[occupant_statecode]
				, [occupant_statuscode] = src.[occupant_statuscode]
				, [property_tenant_tenancy_name] = src.[property_tenant_tenancy_name]
				, [property_tenant_household_name] = src.[property_tenant_household_name]
				, [property_tenancy_household_identifier] = src.[property_tenancy_household_identifier]
				, [property_tenant_number_of_household_members] = src.[property_tenant_number_of_household_members]
				, [property_tenant_named_household_members] = src.[property_tenant_named_household_members]
				, [property_tenant_rent_share_total] = src.[property_tenant_rent_share_total]
				, [property_tenant_total_household_income] = src.[property_tenant_total_household_income]
				, [property_tenant_ethnicity_name] = src.[property_tenant_ethnicity_name]
				, [property_tenant_household_zavanti_status] = src.[property_tenant_household_zavanti_status]
				, [property_tenant_household_amendment_date] = src.[property_tenant_household_amendment_date]
				, [occupant_is_main_applicant_flag] = src.[occupant_is_main_applicant_flag]
				, [property_tenant_created_datetime] = src.[property_tenant_created_datetime]
				, [property_tenant_modified_datetime] = src.[property_tenant_modified_datetime]
				, [occupant_gender_label] = src.[occupant_gender_label]
				, [occupant_disability_label] = src.[occupant_disability_label]
				, [occupant_targetgroup_label] = src.[occupant_targetgroup_label]
				, [occupant_employment_label] = src.[occupant_employment_label]
				, [occupant_contacttype_label] = src.[occupant_contacttype_label]
				, [occupant_eatargetgroup_label] =  src.[occupant_eatargetgroup_label]
				, [occupant_state_label] = src.[occupant_state_label]
				, [occupant_status_label] = src.[occupant_status_label]
				, [household_state_label] = src.[household_state_label]
				, [household_status_label] = src.[household_status_label]
				, [property_tenant_opportunity_state] = src.[property_tenant_opportunity_state]
				, [property_tenant_opportunity_status] = src.[property_tenant_opportunity_status]
				, [occupant_emergency_contact_flag] = src.[occupant_emergency_contact_flag]
				, [occupant_iwi_affiliation_flag] = src.[occupant_iwi_affiliation_flag]
				, [occupant_social_works_number_flag] = src.[occupant_social_works_number_flag]
				, [property_tenant_is_delete_flag] = src.[property_tenant_is_delete_flag]
				, [DWHModifiedOn] = @systemCurrentDate
				, [DWHBatchId] = @BatchID
				, [DWHDMLOperation] = isnull(nullif(src.[DWHDMLOperation],'I'),'U')
			-- Soft delete missing records
			when not matched by source and trg.[DWHDMLOperation] <> 'D' then update set [DWHModifiedOn] = @systemCurrentDate, [DWHDMLOperation] = 'D'
			-- Insert new records
			when not matched by target then 
				insert 
				(    dim_property_key
					,dim_property_tenancy_key
					,dim_property_program_key
					,[property_tenancy_id] 
					,[property_tenant_id] 
					,[property_id] 
					,[property_program_id] 
					,[property_subprogram_id] 
					,[property_tenancy_total_rent_amount] 
					,[property_tenant_tenancy_lease_agreement_date_id] 
					,[property_tenant_tenancy_start_date_id] 
					,[property_tenant_first_name] 
					,[property_tenant_last_name] 
					,[property_tenant_full_name] 
					,[property_tenancy_tenant_date_of_birth] 
					,[property_tenant_registration_date] 
					,[property_tenant_client_identifier] 
					,[property_tenant_head_of_household_flag] 
					,[occupant_record_source] 
					,[occupant_statecode] 
					,[occupant_statuscode] 
					,[property_tenant_tenancy_name] 
					,[property_tenant_household_name] 
					,[property_tenancy_household_identifier] 
					,[property_tenant_number_of_household_members] 
					,[property_tenant_named_household_members] 
					,[property_tenant_rent_share_total] 
					,[property_tenant_total_household_income]
					,[property_tenant_ethnicity_name]
					,[property_tenant_household_zavanti_status]
				    ,[property_tenant_household_amendment_date]
					,[occupant_is_main_applicant_flag]
					,[property_tenant_created_datetime] 
					,[property_tenant_modified_datetime] 
					,[occupant_gender_label] 
					,[occupant_disability_label] 
					,[occupant_targetgroup_label] 
					,[occupant_employment_label] 
					,[occupant_contacttype_label]
					,[occupant_eatargetgroup_label]
					,[occupant_state_label] 
					,[occupant_status_label] 
					,[household_state_label] 
					,[household_status_label] 
					,[property_tenant_opportunity_state] 
					,[property_tenant_opportunity_status]
					,[occupant_emergency_contact_flag]
					,[occupant_iwi_affiliation_flag]
					,[occupant_social_works_number_flag]
					,[property_tenant_is_delete_flag]
					,[DWHBatchId] 
					,[DWHCreatedAt] 
					,[DWHModifiedOn] 
					,[DWHDMLOperation] 
					,[DWHSourceSystem] 
				)
				values
				(	src.dim_property_key
					,src.dim_property_tenancy_key
					,src.dim_property_program_key
					,src.[property_tenancy_id] 
					,src.[property_tenant_id] 
					,src.[property_id] 
					,src.[property_program_id] 
					,src.[property_subprogram_id] 
					,src.[property_tenancy_total_rent_amount] 
					,src.[property_tenant_tenancy_lease_agreement_date_id] 
					,src.[property_tenant_tenancy_start_date_id] 
					,src.[property_tenant_first_name] 
					,src.[property_tenant_last_name] 
					,src.[property_tenant_full_name] 
					,src.[property_tenancy_tenant_date_of_birth] 
					,src.[property_tenant_registration_date] 
					,src.[property_tenant_client_identifier] 
					,src.[property_tenant_head_of_household_flag] 
					,src.[occupant_record_source] 
					,src.[occupant_statecode] 
					,src.[occupant_statuscode] 
					,src.[property_tenant_tenancy_name] 
					,src.[property_tenant_household_name] 
					,src.[property_tenancy_household_identifier] 
					,src.[property_tenant_number_of_household_members] 
					,src.[property_tenant_named_household_members] 
					,src.[property_tenant_rent_share_total] 
					,src.[property_tenant_total_household_income]
					,src.[property_tenant_ethnicity_name]
					,src.[property_tenant_household_zavanti_status]
					,src.[property_tenant_household_amendment_date]
					,src.[occupant_is_main_applicant_flag]
					,src.[property_tenant_created_datetime] 
					,src.[property_tenant_modified_datetime] 
					,src.[occupant_gender_label] 
					,src.[occupant_disability_label] 
					,src.[occupant_targetgroup_label] 
					,src.[occupant_employment_label] 
					,src.[occupant_contacttype_label]
					,src.[occupant_eatargetgroup_label]
					,src.[occupant_state_label] 
					,src.[occupant_status_label] 
					,src.[household_state_label] 
					,src.[household_status_label] 
					,src.[property_tenant_opportunity_state] 
					,src.[property_tenant_opportunity_status]
					,src.[occupant_emergency_contact_flag]
				    ,src.[occupant_iwi_affiliation_flag]
				    ,src.[occupant_social_works_number_flag]
					,src.[property_tenant_is_delete_flag]
					,src.[DWHBatchId] 
					,src.[DWHCreatedAt] 
					,src.[DWHModifiedOn] 
					,src.[DWHDMLOperation] 
					,src.[DWHSourceSystem] 
				);
	end;

		-- Get process counts
		select
		@targetRecords = count(1) 
			, @insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			, @updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			, @deletedRecords = sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
	from [edw].[fact_property_tenant];

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

		if (@pOutputParamsAsDataset = 1)
		begin
		-- Select return parameters as a dataset
		select @pErrorRecords	as ErrorRecords,
			@pInsertRecords as InsertRecords,
			@pUpdateRecords as UpdateRecords,
			@pDeleteRecords as DeleteRecords,
			@pCompleted		as Completed,
			@targetRecords	as TargetRecords;
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
			@targetRecords	as TargetRecords;
	end;
end;