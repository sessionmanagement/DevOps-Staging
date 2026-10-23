

create procedure [edw].[Updateedwdim_course] 
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
	declare @SourceSystem nvarchar(120) = '[ETL].[dim_course]';
	
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
	select @stagedRecords = count(1) from [Staging].[ODSETLdim_course];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[dim_course];

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
		 [course_id] bigint null
		,[MergeAction] varchar(10)
	);
	begin transaction;

	begin try
		if( not exists (select top(1) 1 from [edw].[dim_course]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[dim_course]
			(
				 [course_id] 
				,[course_full_name] 
				,[course_short_name] 
				,[course_id_number] 
				,[course_format] 
				,[course_start_date] 
				,[course_end_date] 
				,[course_created_date] 
				,[is_enable_completion] 
				,[course_category_id] 
				,[course_category_name] 
				,[course_category_path_id] 
				,[course_category_path] 
				,[course_linked_to_certification] 
				,[is_course_visible] 
				,[course_audience_visible] 
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
			)
			select
				 src.[course_id] 
				,src.[course_full_name] 
				,src.[course_short_name] 
				,src.[course_id_number] 
				,src.[course_format] 
				,src.[course_start_date] 
				,src.[course_end_date] 
				,src.[course_created_date] 
				,src.[is_enable_completion] 
				,src.[course_category_id] 
				,src.[course_category_name] 
				,src.[course_category_path_id] 
				,src.[course_category_path] 
				,src.[course_linked_to_certification] 
				,src.[is_course_visible] 
				,src.[course_audience_visible] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLdim_course] as src;
		end else begin
			merge into [edw].[dim_course] as trg
			using 
			(
				select
				 src.[course_id] 
				,src.[course_full_name] 
				,src.[course_short_name] 
				,src.[course_id_number] 
				,src.[course_format] 
				,src.[course_start_date] 
				,src.[course_end_date] 
				,src.[course_created_date] 
				,src.[is_enable_completion] 
				,src.[course_category_id] 
				,src.[course_category_name] 
				,src.[course_category_path_id] 
				,src.[course_category_path] 
				,src.[course_linked_to_certification] 
				,src.[is_course_visible] 
				,src.[course_audience_visible] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLdim_course] as src
			) as src on (src.[course_id] = trg.[course_id] and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
				select src.[course_full_name], src.[course_short_name], src.[course_id_number], src.[course_format], src.[course_start_date], src.[course_end_date], src.[course_created_date], src.[is_enable_completion], src.[course_category_id], src.[course_category_name], src.[course_category_path_id], src.[course_category_path], src.[course_linked_to_certification], src.[is_course_visible], src.[course_audience_visible], case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
				except
				select trg.[course_full_name], trg.[course_short_name], trg.[course_id_number], trg.[course_format], trg.[course_start_date], trg.[course_end_date], trg.[course_created_date], trg.[is_enable_completion], trg.[course_category_id], trg.[course_category_name], trg.[course_category_path_id], trg.[course_category_path], trg.[course_linked_to_certification], trg.[is_course_visible], trg.[course_audience_visible], 'X'
			) then  update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Soft delete missing records
			when not matched by source and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo and trg.[DWHDMLOperation] <> 'D' then update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [course_id] 
					,[course_full_name] 
					,[course_short_name] 
					,[course_id_number] 
					,[course_format] 
					,[course_start_date] 
					,[course_end_date] 
					,[course_created_date] 
					,[is_enable_completion] 
					,[course_category_id] 
					,[course_category_name] 
					,[course_category_path_id] 
					,[course_category_path] 
					,[course_linked_to_certification] 
					,[is_course_visible] 
					,[course_audience_visible] 
					,[DWHBatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperation] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[course_id] 
					,src.[course_full_name] 
					,src.[course_short_name] 
					,src.[course_id_number] 
					,src.[course_format] 
					,src.[course_start_date] 
					,src.[course_end_date] 
					,src.[course_created_date] 
					,src.[is_enable_completion] 
					,src.[course_category_id] 
					,src.[course_category_name] 
					,src.[course_category_path_id] 
					,src.[course_category_path] 
					,src.[course_linked_to_certification] 
					,src.[is_course_visible] 
					,src.[course_audience_visible] 
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[course_id],inserted.[course_id]), $action As [MergeAction] into #SummaryOfChanges;

			-- Insert new versions of previously updated records (Updates and Deletes)
			insert into [edw].[dim_course]
			(
				 [course_id] 
				,[course_full_name] 
				,[course_short_name] 
				,[course_id_number] 
				,[course_format] 
				,[course_start_date] 
				,[course_end_date] 
				,[course_created_date] 
				,[is_enable_completion] 
				,[course_category_id] 
				,[course_category_name] 
				,[course_category_path_id] 
				,[course_category_path] 
				,[course_linked_to_certification] 
				,[is_course_visible] 
				,[course_audience_visible] 
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
			)
			select
				 src.[course_id] 
				,src.[course_full_name] 
				,src.[course_short_name] 
				,src.[course_id_number] 
				,src.[course_format] 
				,src.[course_start_date] 
				,src.[course_end_date] 
				,src.[course_created_date] 
				,src.[is_enable_completion] 
				,src.[course_category_id] 
				,src.[course_category_name] 
				,src.[course_category_path_id] 
				,src.[course_category_path] 
				,src.[course_linked_to_certification] 
				,src.[is_course_visible] 
				,src.[course_audience_visible] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLdim_course]'
				,'U'
			from #SummaryOfChanges as base
			inner join [Staging].[ODSETLdim_course] as src on src.[course_id] = base.[course_id]
			where base.[MergeAction] = 'UPDATE'

			union all 

			select
				 tbl.[course_id] 
				,tbl.[course_full_name] 
				,tbl.[course_short_name] 
				,tbl.[course_id_number] 
				,tbl.[course_format] 
				,tbl.[course_start_date] 
				,tbl.[course_end_date] 
				,tbl.[course_created_date] 
				,tbl.[is_enable_completion] 
				,tbl.[course_category_id] 
				,tbl.[course_category_name] 
				,tbl.[course_category_path_id] 
				,tbl.[course_category_path] 
				,tbl.[course_linked_to_certification] 
				,tbl.[is_course_visible] 
				,tbl.[course_audience_visible] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLdim_course]'
				,'D'
			from #SummaryOfChanges as base
			inner join [edw].[dim_course] as tbl on tbl.[course_id] = base.[course_id] and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			left join [Staging].[ODSETLdim_course] as src on src.[course_id] = base.[course_id]
			where base.[MergeAction] = 'UPDATE'
			and  src.[course_id] is null;
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[dim_course]
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