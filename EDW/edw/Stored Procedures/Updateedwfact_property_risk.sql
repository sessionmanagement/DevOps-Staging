CREATE procedure [edw].[Updateedwfact_property_risk]

/**********************************************************************************************************
 Procedure		[edw].[Updateedwfact_property_risk]
 Author			GitHub Copilot
 Created		
 Purpose		Updates the edw table edw.fact_property_risk with slowly changing dimension Type 2 logic
 Notes:			Called by ETL
 =========================================================================================================
 REVISIONS:
 Version	Date			Author				Description
-------		------------	----------------	-------------------------
 1.0		2025-04-16		Greg Nuthall		Initial version
 1.1		2026-02-24		GitHub Copilot		Removed 8 columns per work item 12210
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
	declare @SourceSystem nvarchar(120) = 'Zavanti.vw_zav_riskregister';

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
	select @stagedRecords = count(1)
	from [Staging].[ODSETLfact_property_risk];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1)
		from [edw].[fact_property_risk];

		-- Select success details
		select
			@pErrorRecords = 0
			, @pInsertRecords = 0
			, @pUpdateRecords = 0
			, @pDeleteRecords = 0
			, @pCompleted = 1
			, @pTargetRecords = @targetRecords

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
		[property_risk_id] uniqueidentifier null
		,
		[MergeAction] varchar(10)
	);
	begin transaction;

	begin try
		if( not exists (select top(1)
		1
	from [edw].[fact_property_risk]) )
		begin
		-- There are no records in the target; insert all
		insert into [edw].[fact_property_risk]
			(
			[property_risk_id]
			,[riskregister_row_id]
			,dim_property_key
			,dim_property_tenancy_key
			,[property_id]
			,[property_tenancy_id]
			,[property_household_id]
			,[property_householdmember_id]
			,[property_risk_contact_id]
			,[property_risk_application_id]
			,[property_risk_category_id]
			,[property_risk_category_name]
			,[property_risk_subcategory_id]
			,[property_risk_subcategory_name]
			,[risk_status_label]
			,[property_risk_name]
			,[property_risk_comments]
			,[property_risk_contact_name]
			,[property_risk_householdmember_name]
			,[property_risk_household_name]
			,[property_risk_tenancy_name]
			,[property_risk_property_name]
			,[property_risk_application_name]
			,[property_risk_chintaro_id]
			,[property_risk_date_registered]
			,[property_risk_date_next_review]
			,[risk_state_code]
			,[risk_status_code_crm]
			,[risk_is_delete_flag]
			,[DWHBatchId]
			,[DWHEffectiveFrom]
			,[DWHEffectiveTo]
			,[DWHDMLOperation]
			,[DWHIsCurrent]
			,[DWHSourceSystem]
			)
		select
			src.[property_risk_id] 
				, src.[riskregister_row_id] 
				, src.dim_property_key
				, src.dim_property_tenancy_key
				, src.[property_id] 
				, src.[property_tenancy_id] 
				, src.[property_household_id] 
				, src.[property_householdmember_id] 
				, src.[property_risk_contact_id] 
				, src.[property_risk_application_id] 
				, src.[property_risk_category_id] 
				, src.[property_risk_category_name] 
				, src.[property_risk_subcategory_id] 
				, src.[property_risk_subcategory_name] 
				, src.[risk_status_label] 
				, src.[property_risk_name] 
				, src.[property_risk_comments] 
				, src.[property_risk_contact_name] 
				, src.[property_risk_householdmember_name] 
				, src.[property_risk_household_name] 
				, src.[property_risk_tenancy_name] 
				, src.[property_risk_property_name] 
				, src.[property_risk_application_name] 
				, src.[property_risk_chintaro_id] 
				, src.[property_risk_date_registered] 
				, src.[property_risk_date_next_review] 
				, src.[risk_state_code] 
				, src.[risk_status_code_crm] 
				, src.[risk_is_delete_flag] 
				, @BatchID as [DWHBatchId]
				, convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				, convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				, 'I' as [DWHDMLOperation]
				, 1 as [DWHIsCurrent]
				, @SourceSystem as [EDWSourceSystem]
		from [Staging].[ODSETLfact_property_risk] as src;
	end else begin
		merge into [edw].[fact_property_risk] as trg
			using 
			(
				select
			src.[property_risk_id] 
				, src.[riskregister_row_id] 
				, src.dim_property_key
				, src.dim_property_tenancy_key
				, src.[property_id] 
				, src.[property_tenancy_id] 
				, src.[property_household_id] 
				, src.[property_householdmember_id] 
				, src.[property_risk_contact_id] 
				, src.[property_risk_application_id] 
				, src.[property_risk_category_id] 
				, src.[property_risk_category_name] 
				, src.[property_risk_subcategory_id] 
				, src.[property_risk_subcategory_name] 
				, src.[risk_status_label] 
				, src.[property_risk_name] 
				, src.[property_risk_comments] 
				, src.[property_risk_contact_name] 
				, src.[property_risk_householdmember_name] 
				, src.[property_risk_household_name] 
				, src.[property_risk_tenancy_name] 
				, src.[property_risk_property_name] 
				, src.[property_risk_application_name] 
				, src.[property_risk_chintaro_id] 
				, src.[property_risk_date_registered] 
				, src.[property_risk_date_next_review] 
				, src.[risk_state_code] 
				, src.[risk_status_code_crm] 
				, src.[risk_is_delete_flag] 
				, @BatchID as [DWHBatchId]
				, convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				, convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				, 'I' as [DWHDMLOperation]
				, 1 as [DWHIsCurrent]
				, @SourceSystem as [DWHSourceSystem]
		from [Staging].[ODSETLfact_property_risk] as src
			) as src on (src.[property_risk_id] = trg.[property_risk_id] and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
																			select src.[riskregister_row_id], src.[property_id], src.[property_tenancy_id], src.[property_household_id], src.[property_householdmember_id], src.[property_risk_contact_id], src.[property_risk_application_id], src.[property_risk_category_id], src.[property_risk_category_name], src.[property_risk_subcategory_id], src.[property_risk_subcategory_name], src.[risk_status_label], src.[property_risk_name], src.[property_risk_comments], src.[property_risk_contact_name], src.[property_risk_householdmember_name], src.[property_risk_household_name], src.[property_risk_tenancy_name], src.[property_risk_property_name], src.[property_risk_application_name], src.[property_risk_chintaro_id], src.[property_risk_date_registered], src.[property_risk_date_next_review], src.[risk_state_code], src.[risk_status_code_crm], src.[risk_is_delete_flag], case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
		except
			select trg.[riskregister_row_id], trg.[property_id], trg.[property_tenancy_id], trg.[property_household_id], trg.[property_householdmember_id], trg.[property_risk_contact_id], trg.[property_risk_application_id], trg.[property_risk_category_id], trg.[property_risk_category_name], trg.[property_risk_subcategory_id], trg.[property_risk_subcategory_name], trg.[risk_status_label], trg.[property_risk_name], trg.[property_risk_comments], trg.[property_risk_contact_name], trg.[property_risk_householdmember_name], trg.[property_risk_household_name], trg.[property_risk_tenancy_name], trg.[property_risk_property_name], trg.[property_risk_application_name], trg.[property_risk_chintaro_id], trg.[property_risk_date_registered], trg.[property_risk_date_next_review], trg.[risk_state_code], trg.[risk_status_code_crm], trg.[risk_is_delete_flag], 'X'
			) then  update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Soft delete missing records
			when not matched by source and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo and trg.[DWHDMLOperation] <> 'D' then update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [property_risk_id] 
					,[riskregister_row_id] 
					,dim_property_key
					,dim_property_tenancy_key
					,[property_id] 
					,[property_tenancy_id] 
					,[property_household_id] 
					,[property_householdmember_id] 
					,[property_risk_contact_id] 
					,[property_risk_application_id] 
					,[property_risk_category_id] 
					,[property_risk_category_name] 
					,[property_risk_subcategory_id] 
					,[property_risk_subcategory_name] 
					,[risk_status_label] 
					,[property_risk_name] 
					,[property_risk_comments] 
					,[property_risk_contact_name] 
					,[property_risk_householdmember_name] 
					,[property_risk_household_name] 
					,[property_risk_tenancy_name] 
					,[property_risk_property_name] 
					,[property_risk_application_name] 
					,[property_risk_chintaro_id] 
					,[property_risk_date_registered] 
					,[property_risk_date_next_review] 
					,[risk_state_code] 
					,[risk_status_code_crm] 
					,[risk_is_delete_flag] 
					,[DWHBatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperation] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[property_risk_id] 
					,src.[riskregister_row_id]
					,src.dim_property_key
					,src.dim_property_tenancy_key
					,src.[property_id] 
					,src.[property_tenancy_id] 
					,src.[property_household_id] 
					,src.[property_householdmember_id] 
					,src.[property_risk_contact_id] 
					,src.[property_risk_application_id] 
					,src.[property_risk_category_id] 
					,src.[property_risk_category_name] 
					,src.[property_risk_subcategory_id] 
					,src.[property_risk_subcategory_name] 
					,src.[risk_status_label] 
					,src.[property_risk_name] 
					,src.[property_risk_comments] 
					,src.[property_risk_contact_name] 
					,src.[property_risk_householdmember_name] 
					,src.[property_risk_household_name] 
					,src.[property_risk_tenancy_name] 
					,src.[property_risk_property_name] 
					,src.[property_risk_application_name] 
					,src.[property_risk_chintaro_id] 
					,src.[property_risk_date_registered] 
					,src.[property_risk_date_next_review] 
					,src.[risk_state_code] 
					,src.[risk_status_code_crm] 
					,src.[risk_is_delete_flag] 
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[property_risk_id],inserted.[property_risk_id]), $action As [MergeAction] into #SummaryOfChanges;

		-- Insert new versions of previously updated records (Updates and Deletes)
		insert into [edw].[fact_property_risk]
			(
			[property_risk_id]
			,[riskregister_row_id]
			,dim_property_key
			,dim_property_tenancy_key
			,[property_id]
			,[property_tenancy_id]
			,[property_household_id]
			,[property_householdmember_id]
			,[property_risk_contact_id]
			,[property_risk_application_id]
			,[property_risk_category_id]
			,[property_risk_category_name]
			,[property_risk_subcategory_id]
			,[property_risk_subcategory_name]
			,[risk_status_label]
			,[property_risk_name]
			,[property_risk_comments]
			,[property_risk_contact_name]
			,[property_risk_householdmember_name]
			,[property_risk_household_name]
			,[property_risk_tenancy_name]
			,[property_risk_property_name]
			,[property_risk_application_name]
			,[property_risk_chintaro_id]
			,[property_risk_date_registered]
			,[property_risk_date_next_review]
			,[risk_state_code]
			,[risk_status_code_crm]
			,[risk_is_delete_flag]
			,[DWHBatchId]
			,[DWHEffectiveFrom]
			,[DWHEffectiveTo]
			,[DWHIsCurrent]
			,[DWHSourceSystem]
			,[DWHDMLOperation]
			)
					select
				src.[property_risk_id] 
				, src.[riskregister_row_id] 
				, src.dim_property_key
				, src.dim_property_tenancy_key
				, src.[property_id] 
				, src.[property_tenancy_id] 
				, src.[property_household_id] 
				, src.[property_householdmember_id] 
				, src.[property_risk_contact_id] 
				, src.[property_risk_application_id] 
				, src.[property_risk_category_id] 
				, src.[property_risk_category_name] 
				, src.[property_risk_subcategory_id] 
				, src.[property_risk_subcategory_name] 
				, src.[risk_status_label] 
				, src.[property_risk_name] 
				, src.[property_risk_comments] 
				, src.[property_risk_contact_name] 
				, src.[property_risk_householdmember_name] 
				, src.[property_risk_household_name] 
				, src.[property_risk_tenancy_name] 
				, src.[property_risk_property_name] 
				, src.[property_risk_application_name] 
				, src.[property_risk_chintaro_id] 
				, src.[property_risk_date_registered] 
				, src.[property_risk_date_next_review] 
				, src.[risk_state_code] 
				, src.[risk_status_code_crm] 
				, src.[risk_is_delete_flag] 
				, @BatchID
				, @SystemEffectiveFrom
				, @SystemDefaultEffectiveTo
				, 1
				, 'Zavanti.vw_zav_riskregister'
				, 'U'
			from #SummaryOfChanges as base
				inner join [Staging].[ODSETLfact_property_risk] as src on src.[property_risk_id] = base.[property_risk_id]
			where base.[MergeAction] = 'UPDATE'

		union all

			select
				tbl.[property_risk_id] 
				, tbl.[riskregister_row_id] 
				, tbl.dim_property_key
				, tbl.dim_property_tenancy_key
				, tbl.[property_id] 
				, tbl.[property_tenancy_id] 
				, tbl.[property_household_id] 
				, tbl.[property_householdmember_id] 
				, tbl.[property_risk_contact_id] 
				, tbl.[property_risk_application_id] 
				, tbl.[property_risk_category_id] 
				, tbl.[property_risk_category_name] 
				, tbl.[property_risk_subcategory_id] 
				, tbl.[property_risk_subcategory_name] 
				, tbl.[risk_status_label] 
				, tbl.[property_risk_name] 
				, tbl.[property_risk_comments] 
				, tbl.[property_risk_contact_name] 
				, tbl.[property_risk_householdmember_name] 
				, tbl.[property_risk_household_name] 
				, tbl.[property_risk_tenancy_name] 
				, tbl.[property_risk_property_name] 
				, tbl.[property_risk_application_name] 
				, tbl.[property_risk_chintaro_id] 
				, tbl.[property_risk_date_registered] 
				, tbl.[property_risk_date_next_review] 
				, tbl.[risk_state_code] 
				, tbl.[risk_status_code_crm] 
				, tbl.[risk_is_delete_flag] 
				, @BatchID
				, @SystemEffectiveFrom
				, @SystemDefaultEffectiveTo
				, 1
				, 'Zavanti.vw_zav_riskregister'
				, 'D'
			from #SummaryOfChanges as base
				inner join [edw].[fact_property_risk] as tbl on tbl.[property_risk_id] = base.[property_risk_id] and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
				left join [Staging].[ODSETLfact_property_risk] as src on src.[property_risk_id] = base.[property_risk_id]
			where base.[MergeAction] = 'UPDATE'
				and src.[property_risk_id] is null;
	end;

		-- Get process counts
		select
		@targetRecords = count(1) 
			, @insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			, @updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			, @deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
	from [edw].[fact_property_risk]
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