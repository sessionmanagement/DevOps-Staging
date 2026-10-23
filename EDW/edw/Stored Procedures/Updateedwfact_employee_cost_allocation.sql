

create procedure [edw].[Updateedwfact_employee_cost_allocation] 
	@pBatchID int, 
	@pIndexRebuildThreshold int,
	@pOutputParamsAsDataset int = 0,
	@pErrorRecords int = null OUTPUT, 
	@pInsertRecords int = null OUTPUT, 
	@pUpdateRecords int = null OUTPUT, 
	@pDeleteRecords int = null OUTPUT,
	@pCompleted int = null OUTPUT,
	@pTargetRecords int = null OUTPUT 
as begin

	set nocount on;
	set xact_abort on;

	-- Variables
	declare @batchID int = @pBatchID;
	declare @SourceSystem nvarchar(120) = 'DataPay.cost_allocations';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	-- Do not run if there are records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLfact_employee_cost_allocation];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[fact_employee_cost_allocation];

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
					@targetRecords	as TargetRecords;
		end;

		return;
	end;

	begin transaction;

	begin try
		if( not exists (select top(1) 1 from [edw].[fact_employee_cost_allocation]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[fact_employee_cost_allocation]
			(
				 [dim_employee_key]
				,[dim_company_key]
				,[dim_service_key]
				,[dim_business_unit_hierarchy_key]
				,[employee_id] 
				,[intellihr_business_unit_id] 
				,[intellihr_business_unit_code] 
				,[intellihr_business_unit_name] 
				,[datapay_cost_center_code] 
				,[datapay_cost_center_name] 
				,[cost_allocation_percentage] 
				,[job_title] 
				,[company_id] 
				,[DWHBatchId] 
				,[DWHCreatedAt] 
				,[DWHModifiedOn] 
				,[DWHDMLOperation] 
				,[DWHSourceSystem] 
			)
			select
				 src.[dim_employee_key]
				,src.[dim_company_key]
				,src.[dim_service_key]
				,src.[dim_business_unit_hierarchy_key]
				,src.[employee_id] 
				,src.[intellihr_business_unit_id] 
				,src.[intellihr_business_unit_code] 
				,src.[intellihr_business_unit_name] 
				,src.[datapay_cost_center_code] 
				,src.[datapay_cost_center_name] 
				,src.[cost_allocation_percentage] 
				,src.[job_title] 
				,src.[company_id] 
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLfact_employee_cost_allocation] as src;
		end else begin
			merge into [edw].[fact_employee_cost_allocation] as trg
			using 
			(
				select
				 src.[dim_employee_key]
				,src.[dim_company_key]
				,src.[dim_service_key]
				,src.[dim_business_unit_hierarchy_key]
				,src.[employee_id] 
				,src.[intellihr_business_unit_id] 
				,src.[intellihr_business_unit_code] 
				,src.[intellihr_business_unit_name] 
				,src.[datapay_cost_center_code] 
				,src.[datapay_cost_center_name] 
				,src.[cost_allocation_percentage] 
				,src.[job_title] 
				,src.[company_id] 
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLfact_employee_cost_allocation] as src
			) as src on (src.[employee_id] = trg.[employee_id] and src.[datapay_cost_center_code] = trg.[datapay_cost_center_code] collate database_default and src.[company_id] = trg.[company_id] collate database_default)			-- Retire existing records
			when matched and exists 
			( 
				select src.[dim_employee_key], src.[dim_company_key], src.[dim_service_key], src.[dim_business_unit_hierarchy_key], src.[intellihr_business_unit_id], src.[intellihr_business_unit_code], src.[intellihr_business_unit_name], src.[datapay_cost_center_name], src.[cost_allocation_percentage], src.[job_title]
				except
				select trg.[dim_employee_key], trg.[dim_company_key], trg.[dim_service_key], trg.[dim_business_unit_hierarchy_key], trg.[intellihr_business_unit_id], trg.[intellihr_business_unit_code], trg.[intellihr_business_unit_name], trg.[datapay_cost_center_name], trg.[cost_allocation_percentage], trg.[job_title]
			) then  update set 
				 [dim_employee_key] = src.[dim_employee_key]
				, [dim_company_key] = src.[dim_company_key]
				, [dim_service_key] = src.[dim_service_key]
				, [dim_business_unit_hierarchy_key] = src.[dim_business_unit_hierarchy_key]
				, [employee_id] = src.[employee_id]
				, [intellihr_business_unit_id] = src.[intellihr_business_unit_id]
				, [intellihr_business_unit_code] = src.[intellihr_business_unit_code]
				, [intellihr_business_unit_name] = src.[intellihr_business_unit_name]
				, [datapay_cost_center_code] = src.[datapay_cost_center_code]
				, [datapay_cost_center_name] = src.[datapay_cost_center_name]
				, [cost_allocation_percentage] = src.[cost_allocation_percentage]
				, [job_title] = src.[job_title]
				, [company_id] = src.[company_id]
				,[DWHModifiedOn] = @systemCurrentDate
				,[DWHBatchId] = @BatchID
				,[DWHDMLOperation] = isnull(nullif(src.[DWHDMLOperation],'I'),'U')
			-- Soft delete missing records
			when not matched by source and trg.[DWHDMLOperation] <> 'D' then update set [DWHModifiedOn] = @systemCurrentDate, [DWHDMLOperation] = 'D'
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [dim_employee_key]
					,[dim_company_key]
					,[dim_service_key]
					,[dim_business_unit_hierarchy_key]
					,[employee_id] 
					,[intellihr_business_unit_id] 
					,[intellihr_business_unit_code] 
					,[intellihr_business_unit_name] 
					,[datapay_cost_center_code] 
					,[datapay_cost_center_name] 
					,[cost_allocation_percentage] 
					,[job_title] 
					,[company_id] 
					,[DWHBatchId] 
					,[DWHCreatedAt] 
					,[DWHModifiedOn] 
					,[DWHDMLOperation] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[dim_employee_key]
					,src.[dim_company_key]
					,src.[dim_service_key]
					,src.[dim_business_unit_hierarchy_key]
					,src.[employee_id] 
					,src.[intellihr_business_unit_id] 
					,src.[intellihr_business_unit_code] 
					,src.[intellihr_business_unit_name] 
					,src.[datapay_cost_center_code] 
					,src.[datapay_cost_center_name] 
					,src.[cost_allocation_percentage] 
					,src.[job_title] 
					,src.[company_id] 
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
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords = sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[fact_employee_cost_allocation];

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