create procedure [edw].[Updateedwdim_client_interaction_type] 
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
	declare @SourceSystem nvarchar(120) = '[ETL].[dim_client_interaction_type]';
	
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
	select @stagedRecords = count(1) from [Staging].[ODSETLdim_client_interaction_type];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[dim_client_interaction_type];

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
		 [company_key] int not null		,[client_interaction_type_id] int null
		,[MergeAction] varchar(10)
	);
	begin transaction;

	begin try
		if( not exists (select top(1) 1 from [edw].[dim_client_interaction_type]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[dim_client_interaction_type]
			(
				 [company_key] 				,[client_interaction_type_id] 				,[client_interaction_type_code] 				,[client_interaction_type_name] 				,[client_parent_interaction_type_code] 				,[client_parent_interaction_type_name] 				,[DWHBatchId] 				,[DWHEffectiveFrom] 				,[DWHEffectiveTo] 				,[DWHDMLOperation] 				,[DWHIsCurrent] 				,[DWHSourceSystem] 
			)
			select
				 src.[company_key] 				,src.[client_interaction_type_id] 				,src.[client_interaction_type_code] 				,src.[client_interaction_type_name] 				,src.[client_parent_interaction_type_code] 				,src.[client_parent_interaction_type_name] 				,@BatchID as [DWHBatchId]				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]				,'I' as [DWHDMLOperation]				,1 as [DWHIsCurrent]				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLdim_client_interaction_type] as src;
		end else begin
			merge into [edw].[dim_client_interaction_type] as trg
			using 
			(
				select
				 src.[company_key] 				,src.[client_interaction_type_id] 				,src.[client_interaction_type_code] 				,src.[client_interaction_type_name] 				,src.[client_parent_interaction_type_code] 				,src.[client_parent_interaction_type_name] 				,@BatchID as [DWHBatchId]				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]				,'I' as [DWHDMLOperation]				,1 as [DWHIsCurrent]				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLdim_client_interaction_type] as src
			) as src on (src.[company_key] = trg.[company_key] and src.[client_interaction_type_id] = trg.[client_interaction_type_id] and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
				select src.[client_interaction_type_code], src.[client_interaction_type_name], src.[client_parent_interaction_type_code], src.[client_parent_interaction_type_name], case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
				except
				select trg.[client_interaction_type_code], trg.[client_interaction_type_name], trg.[client_parent_interaction_type_code], trg.[client_parent_interaction_type_name], 'X'
			) then  update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Soft delete missing records
			when not matched by source and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo and trg.[DWHDMLOperation] <> 'D' then update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [company_key] 					,[client_interaction_type_id] 					,[client_interaction_type_code] 					,[client_interaction_type_name] 					,[client_parent_interaction_type_code] 					,[client_parent_interaction_type_name] 					,[DWHBatchId] 					,[DWHEffectiveFrom] 					,[DWHEffectiveTo] 					,[DWHDMLOperation] 					,[DWHIsCurrent] 					,[DWHSourceSystem] 
				)
				values
				(
					 src.[company_key] 					,src.[client_interaction_type_id] 					,src.[client_interaction_type_code] 					,src.[client_interaction_type_name] 					,src.[client_parent_interaction_type_code] 					,src.[client_parent_interaction_type_name] 					,src.[DWHBatchId] 					,src.[DWHEffectiveFrom] 					,src.[DWHEffectiveTo] 					,src.[DWHDMLOperation] 					,src.[DWHIsCurrent] 					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[company_key],inserted.[company_key]), coalesce(src.[client_interaction_type_id],inserted.[client_interaction_type_id]), $action As [MergeAction] into #SummaryOfChanges;

			-- Insert new versions of previously updated records (Updates and Deletes)
			insert into [edw].[dim_client_interaction_type]
			(
				 [company_key] 				,[client_interaction_type_id] 				,[client_interaction_type_code] 				,[client_interaction_type_name] 				,[client_parent_interaction_type_code] 				,[client_parent_interaction_type_name] 
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
			)
			select
				 src.[company_key] 				,src.[client_interaction_type_id] 				,src.[client_interaction_type_code] 				,src.[client_interaction_type_name] 				,src.[client_parent_interaction_type_code] 				,src.[client_parent_interaction_type_name] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLdim_client_interaction_type]'
				,'U'
			from #SummaryOfChanges as base
			inner join [Staging].[ODSETLdim_client_interaction_type] as src on src.[company_key] = base.[company_key] and src.[client_interaction_type_id] = base.[client_interaction_type_id]
			where base.[MergeAction] = 'UPDATE'

			union all 

			select
				 tbl.[company_key] 				,tbl.[client_interaction_type_id] 				,tbl.[client_interaction_type_code] 				,tbl.[client_interaction_type_name] 				,tbl.[client_parent_interaction_type_code] 				,tbl.[client_parent_interaction_type_name] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLdim_client_interaction_type]'
				,'D'
			from #SummaryOfChanges as base
			inner join [edw].[dim_client_interaction_type] as tbl on tbl.[company_key] = base.[company_key] and tbl.[client_interaction_type_id] = base.[client_interaction_type_id] and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			left join [Staging].[ODSETLdim_client_interaction_type] as src on src.[company_key] = base.[company_key] and src.[client_interaction_type_id] = base.[client_interaction_type_id]
			where base.[MergeAction] = 'UPDATE'
			and  src.[company_key] is null and src.[client_interaction_type_id] is null;
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[dim_client_interaction_type]
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
GO

