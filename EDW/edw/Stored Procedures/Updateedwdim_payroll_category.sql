


CREATE procedure [edw].[Updateedwdim_payroll_category] 
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
	declare @SourceSystem nvarchar(120) = '[ETL].[dim_payroll_category]';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	-- Do not run if there are records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLdim_payroll_category];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[dim_payroll_category];

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

		IF (
			NOT EXISTS (
				SELECT 1
				FROM [edw].[dim_payroll_category]
				WHERE dim_payroll_category_key <= 0
				)
			)
		BEGIN
			-- turn the identity insert on 
			SET IDENTITY_INSERT [edw].[dim_payroll_category] ON

			INSERT INTO [edw].[dim_payroll_category] (
				[dim_payroll_category_key]
				,[payroll_category_id]
				,[payroll_category_name]
				,[payroll_category_short_name]
				,[payroll_category_add_to_duration_flag]
				,[payroll_category_hours_worked_flag]
				,[DWHSourceSystem]
				,[DWHBatchId]
				,[DWHDMLOperation]
				,[DWHCreatedAt]
				,[DWHModifiedOn]
				)
			VALUES (
				0
				,NULL
				,'N/A'
				,'N/A'
				,NULL
				,NULL
				,@SourceSystem
				,0
				,'I'
				,@systemCurrentDate
				,@systemCurrentDate
				)
				,(
				- 1
				,NULL
				,'Unknown'
				,'Unknown'
				,NULL
				,NULL
				,@SourceSystem
				,0
				,'I'
				,@systemCurrentDate
				,@systemCurrentDate
				)

			-- turn the identity insert off
			SET IDENTITY_INSERT [edw].[dim_payroll_category] OFF
		END




		if( not exists (select top(1) 1 from [edw].[dim_payroll_category]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[dim_payroll_category]
			(
				 [payroll_category_id] 
				,[payroll_category_name] 
				,[payroll_category_short_name] 
				,[payroll_category_add_to_duration_flag] 
				,[payroll_category_hours_worked_flag] 
				,[DWHBatchId] 
				,[DWHCreatedAt] 
				,[DWHModifiedOn] 
				,[DWHDMLOperation] 
				,[DWHSourceSystem] 
			)
			select
				 src.[payroll_category_id] 
				,src.[payroll_category_name] 
				,src.[payroll_category_short_name] 
				,src.[payroll_category_add_to_duration_flag] 
				,src.[payroll_category_hours_worked_flag] 
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLdim_payroll_category] as src;
		end else begin
			merge into [edw].[dim_payroll_category] as trg
			using 
			(
				select
				 src.[payroll_category_id] 
				,src.[payroll_category_name] 
				,src.[payroll_category_short_name] 
				,src.[payroll_category_add_to_duration_flag] 
				,src.[payroll_category_hours_worked_flag] 
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLdim_payroll_category] as src
			) as src on (src.[payroll_category_id] = trg.[payroll_category_id] collate database_default)			-- Retire existing records
			when matched and exists 
			( 
				select src.[payroll_category_name], src.[payroll_category_short_name], src.[payroll_category_add_to_duration_flag], src.[payroll_category_hours_worked_flag]
				except
				select trg.[payroll_category_name], trg.[payroll_category_short_name], trg.[payroll_category_add_to_duration_flag], trg.[payroll_category_hours_worked_flag]
			) then  update set 
				 [payroll_category_id] = src.[payroll_category_id]
				, [payroll_category_name] = src.[payroll_category_name]
				, [payroll_category_short_name] = src.[payroll_category_short_name]
				, [payroll_category_add_to_duration_flag] = src.[payroll_category_add_to_duration_flag]
				, [payroll_category_hours_worked_flag] = src.[payroll_category_hours_worked_flag]
				,[DWHModifiedOn] = @systemCurrentDate
				,[DWHBatchId] = @BatchID
				,[DWHDMLOperation] = isnull(nullif(src.[DWHDMLOperation],'I'),'U')
			-- Soft delete missing records
			when not matched by source 
			and trg.dim_payroll_category_key > 0
			and trg.[DWHDMLOperation] <> 'D' 
			then update set [DWHModifiedOn] = @systemCurrentDate, [DWHDMLOperation] = 'D'
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [payroll_category_id] 
					,[payroll_category_name] 
					,[payroll_category_short_name] 
					,[payroll_category_add_to_duration_flag] 
					,[payroll_category_hours_worked_flag] 
					,[DWHBatchId] 
					,[DWHCreatedAt] 
					,[DWHModifiedOn] 
					,[DWHDMLOperation] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[payroll_category_id] 
					,src.[payroll_category_name] 
					,src.[payroll_category_short_name] 
					,src.[payroll_category_add_to_duration_flag] 
					,src.[payroll_category_hours_worked_flag] 
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
		from [edw].[dim_payroll_category];

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