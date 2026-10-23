

create procedure [edw].[Updateedwdim_certification] 
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
	declare @SourceSystem nvarchar(120) = '[ETL].[dim_certification]';
	
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
			 [certification_id] bigint null
		,[MergeAction] varchar(10)
	);
	begin transaction;
	begin try
		
		IF (
				NOT EXISTS (
					SELECT 1
					FROM [edw].[dim_certification]
					WHERE dim_certification_key <= 0
					)
				)
		BEGIN
			-- turn the identity insert on 
			SET IDENTITY_INSERT [edw].[dim_certification] ON

		INSERT INTO [edw].[dim_certification]
           (dim_certification_key
		   ,[certification_id]
           ,[certification_full_name]
           ,[certification_short_name]
           ,[certification_id_number]
           ,[certification_available_from_date]
           ,[certification_end_date]
           ,[certification_created_date]
           ,[certification_category_id]
           ,[certification_category_name]
           ,[certification_category_path]
           ,[DWHBatchId]
           ,[DWHEffectiveFrom]
           ,[DWHEffectiveTo]
           ,[DWHDMLOperation]
           ,[DWHIsCurrent]
           ,[DWHSourceSystem])
			VALUES
           (-1,
		   -1
           ,'Unknown'
           ,'Unknown'
           ,'Unknown'
           ,'1900-01-01'
           ,'1900-01-01'
           ,'1900-01-01'
           ,-1
           ,'Unknown'
           ,'Unknown'
				,@BatchID 
				,convert(datetime,'1 January 1900') 
				,convert(datetime,'31 December 2999 23:59:59') 
				,'I' 
				,1
				,@SourceSystem ),
				          (0,0
           ,'n/a'
           ,'n/a'
           ,'n/a'
           ,'1900-01-01'
           ,'1900-01-01'
           ,'1900-01-01'
           ,-1
           ,'n/a'
           ,'n/a'
				,@BatchID 
				,convert(datetime,'1 January 1900') 
				,convert(datetime,'31 December 2999 23:59:59') 
				,'I' 
				,1
				,@SourceSystem )

			-- turn the identity insert off
			SET IDENTITY_INSERT [edw].[dim_certification] OFF
		END



	-- Do not run if there are no records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLdim_certification];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[dim_certification];

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
       commit transaction;
		return;
	end;


		if( not exists (select top(1) 1 from [edw].[dim_certification]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[dim_certification]
			(
				 [certification_id] 
				,[certification_full_name] 
				,[certification_short_name] 
				,[certification_id_number] 
				,[certification_available_from_date] 
				,[certification_end_date] 
				,[certification_created_date] 
				,[certification_category_id] 
				,[certification_category_name] 
				,[certification_category_path] 
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
			)
			select
				 src.[certification_id] 
				,src.[certification_full_name] 
				,src.[certification_short_name] 
				,src.[certification_id_number] 
				,src.[certification_available_from_date] 
				,src.[certification_end_date] 
				,src.[certification_created_date] 
				,src.[certification_category_id] 
				,src.[certification_category_name] 
				,src.[certification_category_path] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLdim_certification] as src;
		end else begin
			merge into [edw].[dim_certification] as trg
			using 
			(
				select
				 src.[certification_id] 
				,src.[certification_full_name] 
				,src.[certification_short_name] 
				,src.[certification_id_number] 
				,src.[certification_available_from_date] 
				,src.[certification_end_date] 
				,src.[certification_created_date] 
				,src.[certification_category_id] 
				,src.[certification_category_name] 
				,src.[certification_category_path] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLdim_certification] as src
			) as src on (src.[certification_id] = trg.[certification_id] and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
				select src.[certification_full_name], src.[certification_short_name], src.[certification_id_number], src.[certification_available_from_date], src.[certification_end_date], src.[certification_created_date], src.[certification_category_id], src.[certification_category_name], src.[certification_category_path], case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
				except
				select trg.[certification_full_name], trg.[certification_short_name], trg.[certification_id_number], trg.[certification_available_from_date], trg.[certification_end_date], trg.[certification_created_date], trg.[certification_category_id], trg.[certification_category_name], trg.[certification_category_path], 'X'
			) then  update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Soft delete missing records
			when not matched by source and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo and trg.[DWHDMLOperation] <> 'D' then update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [certification_id] 
					,[certification_full_name] 
					,[certification_short_name] 
					,[certification_id_number] 
					,[certification_available_from_date] 
					,[certification_end_date] 
					,[certification_created_date] 
					,[certification_category_id] 
					,[certification_category_name] 
					,[certification_category_path] 
					,[DWHBatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperation] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[certification_id] 
					,src.[certification_full_name] 
					,src.[certification_short_name] 
					,src.[certification_id_number] 
					,src.[certification_available_from_date] 
					,src.[certification_end_date] 
					,src.[certification_created_date] 
					,src.[certification_category_id] 
					,src.[certification_category_name] 
					,src.[certification_category_path] 
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[certification_id],inserted.[certification_id]), $action As [MergeAction] into #SummaryOfChanges;

			-- Insert new versions of previously updated records (Updates and Deletes)
			insert into [edw].[dim_certification]
			(
				 [certification_id] 
				,[certification_full_name] 
				,[certification_short_name] 
				,[certification_id_number] 
				,[certification_available_from_date] 
				,[certification_end_date] 
				,[certification_created_date] 
				,[certification_category_id] 
				,[certification_category_name] 
				,[certification_category_path] 
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
			)
			select
				 src.[certification_id] 
				,src.[certification_full_name] 
				,src.[certification_short_name] 
				,src.[certification_id_number] 
				,src.[certification_available_from_date] 
				,src.[certification_end_date] 
				,src.[certification_created_date] 
				,src.[certification_category_id] 
				,src.[certification_category_name] 
				,src.[certification_category_path] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLdim_certification]'
				,'U'
			from #SummaryOfChanges as base
			inner join [Staging].[ODSETLdim_certification] as src on src.[certification_id] = base.[certification_id]
			where base.[MergeAction] = 'UPDATE'

			union all 

			select
				 tbl.[certification_id] 
				,tbl.[certification_full_name] 
				,tbl.[certification_short_name] 
				,tbl.[certification_id_number] 
				,tbl.[certification_available_from_date] 
				,tbl.[certification_end_date] 
				,tbl.[certification_created_date] 
				,tbl.[certification_category_id] 
				,tbl.[certification_category_name] 
				,tbl.[certification_category_path] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLdim_certification]'
				,'D'
			from #SummaryOfChanges as base
			inner join [edw].[dim_certification] as tbl on tbl.[certification_id] = base.[certification_id] and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			left join [Staging].[ODSETLdim_certification] as src on src.[certification_id] = base.[certification_id]
			where base.[MergeAction] = 'UPDATE'
			and  src.[certification_id] is null;
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[dim_certification]
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