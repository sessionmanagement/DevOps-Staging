create procedure [edw].[Updateedwfact_client_interaction] 
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
	declare @SourceSystem nvarchar(120) = '[ETL].[fact_client_interaction]';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	-- Do not run if there are records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLfact_client_interaction];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[fact_client_interaction];

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
		if( not exists (select top(1) 1 from [edw].[fact_client_interaction]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[fact_client_interaction]
			(
				 [dim_company_key] 
				,[client_interaction_id] 
				,[client_id] 
				,[client_interaction_type_id] 
				,[dim_client_key]
				,[dim_client_interaction_type_key]
				,[dim_employee_key]
				,[client_interaction_date] 
				,[client_interaction_created_date] 
				,[client_interaction_comments] 
				,[DWHBatchId] 
				,[DWHCreatedAt] 
				,[DWHModifiedOn] 
				,[DWHDMLOperation] 
				,[DWHSourceSystem] 
			)
			select
				 src.[dim_company_key] 
				,src.[client_interaction_id] 
				,src.[client_id] 
				,src.[client_interaction_type_id] 
				,src.[dim_client_key]
				,src.[dim_client_interaction_type_key]
				,src.[dim_employee_key]
				,src.[client_interaction_date] 
				,src.[client_interaction_created_date] 
				,src.[client_interaction_comments] 
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLfact_client_interaction] as src;
		end else begin
			merge into [edw].[fact_client_interaction] as trg
			using 
			(
				select
				 src.[dim_company_key] 
				,src.[client_interaction_id] 
				,src.[client_id] 
				,src.[client_interaction_type_id] 
				,src.[dim_client_key]
				,src.[dim_client_interaction_type_key]
				,src.[dim_employee_key]
				,src.[client_interaction_date] 
				,src.[client_interaction_created_date] 
				,src.[client_interaction_comments] 
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLfact_client_interaction] as src
			) as src on (src.[dim_company_key] = trg.[dim_company_key] and src.[client_interaction_id] = trg.[client_interaction_id] and src.[client_id] = trg.[client_id])			-- Retire existing records
			when matched and exists 
			( 
				select src.[client_interaction_type_id], src.[dim_client_interaction_type_key], src.[dim_employee_key], src.[client_interaction_date], src.[client_interaction_created_date], src.[client_interaction_comments]
				except
				select trg.[client_interaction_type_id], trg.[dim_client_interaction_type_key], trg.[dim_employee_key], trg.[client_interaction_date], trg.[client_interaction_created_date], trg.[client_interaction_comments]
			) then  update set 
				 [dim_company_key] = src.[dim_company_key]
				, [client_interaction_id] = src.[client_interaction_id]
				, [client_id] = src.[client_id]
				, [client_interaction_type_id] = src.[client_interaction_type_id]
				, [dim_client_key] = src.[dim_client_key]
				, [dim_client_interaction_type_key] = src.[dim_client_interaction_type_key]
				, [dim_employee_key] = src.[dim_employee_key]
				, [client_interaction_date] = src.[client_interaction_date]
				, [client_interaction_created_date] = src.[client_interaction_created_date]
				, [client_interaction_comments] = src.[client_interaction_comments]
				,[DWHModifiedOn] = @systemCurrentDate
				,[DWHBatchId] = @BatchID
				,[DWHDMLOperation] = isnull(nullif(src.[DWHDMLOperation],'I'),'U')
			-- Soft delete missing records
			when not matched by source and trg.[DWHDMLOperation] <> 'D' then update set [DWHModifiedOn] = @systemCurrentDate, [DWHDMLOperation] = 'D'
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [dim_company_key] 
					,[client_interaction_id] 
					,[client_id] 
					,[client_interaction_type_id] 
					,[dim_client_key]
					,[dim_client_interaction_type_key]
					,[dim_employee_key]
					,[client_interaction_date] 
					,[client_interaction_created_date] 
					,[client_interaction_comments] 
					,[DWHBatchId] 
					,[DWHCreatedAt] 
					,[DWHModifiedOn] 
					,[DWHDMLOperation] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[dim_company_key] 
					,src.[client_interaction_id] 
					,src.[client_id] 
					,src.[client_interaction_type_id] 
					,src.[dim_client_key]
					,src.[dim_client_interaction_type_key]
					,src.[dim_employee_key]
					,src.[client_interaction_date] 
					,src.[client_interaction_created_date] 
					,src.[client_interaction_comments] 
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
		from [edw].[fact_client_interaction];

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
GO

