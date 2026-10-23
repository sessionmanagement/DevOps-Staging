


/**********************************************************************************************************
 Procedure	[edw].[Updateedwdim_program]
 Author		
 Created		
 Purpose		
				

				
 Notes: Call By	EDW Pipeline '30_Load_From_ODS'
	
 =========================================================================================================

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2024-07-05	  Manish Singh			Initial version


**********************************************************************************************************/

create procedure [edw].[Updateedwdim_program] 
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
	declare @SourceSystem nvarchar(120) = '[ETL].[dim_program]';
	
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
			 [program_id] bigint null
		,[MergeAction] varchar(10)
	);
	begin transaction;
	begin try
		
		IF (
				NOT EXISTS (
					SELECT 1
					FROM [edw].[dim_program]
					WHERE dim_program_key <= 0
					)
				)
		BEGIN
			-- turn the identity insert on 
			SET IDENTITY_INSERT [edw].[dim_program] ON

		INSERT INTO [edw].[dim_program]
           ([program_id]
           ,[program_full_name]
           ,[program_short_name]
           ,[program_id_number]
           ,[available_from_date]
           ,[program_end_date]
           ,[program_created_date]
           ,[program_category_id]
           ,[program_category_name]
           ,[program_category_path]
           ,[DWHBatchId]
           ,[DWHEffectiveFrom]
           ,[DWHEffectiveTo]
           ,[DWHDMLOperation]
           ,[DWHIsCurrent]
           ,[DWHSourceSystem])
			VALUES
           (-1
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
				,@SourceSystem )

			-- turn the identity insert off
			SET IDENTITY_INSERT [edw].[dim_program] OFF
		END



	-- Do not run if there are no records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLdim_program];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[dim_program];

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

			if( not exists (select top(1) 1 from [edw].[dim_program]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[dim_program]
			(
				 [program_id] 
				,[program_full_name] 
				,[program_short_name] 
				,[program_id_number] 
				,[available_from_date] 
				,[program_end_date] 
				,[program_created_date] 
				,[program_category_id] 
				,[program_category_name] 
				,[program_category_path] 
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
			)
			select
				 src.[program_id] 
				,src.[program_full_name] 
				,src.[program_short_name] 
				,src.[program_id_number] 
				,src.[available_from_date] 
				,src.[program_end_date] 
				,src.[program_created_date] 
				,src.[program_category_id] 
				,src.[program_category_name] 
				,src.[program_category_path] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLdim_program] as src;
		end else begin
			merge into [edw].[dim_program] as trg
			using 
			(
				select
				 src.[program_id] 
				,src.[program_full_name] 
				,src.[program_short_name] 
				,src.[program_id_number] 
				,src.[available_from_date] 
				,src.[program_end_date] 
				,src.[program_created_date] 
				,src.[program_category_id] 
				,src.[program_category_name] 
				,src.[program_category_path] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLdim_program] as src
			) as src on (src.[program_id] = trg.[program_id] and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
				select src.[program_full_name], src.[program_short_name], src.[program_id_number], src.[available_from_date], src.[program_end_date], src.[program_created_date], src.[program_category_id], src.[program_category_name], src.[program_category_path], case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
				except
				select trg.[program_full_name], trg.[program_short_name], trg.[program_id_number], trg.[available_from_date], trg.[program_end_date], trg.[program_created_date], trg.[program_category_id], trg.[program_category_name], trg.[program_category_path], 'X'
			) then  update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Soft delete missing records
			when not matched by source and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo and trg.[DWHDMLOperation] <> 'D' then update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [program_id] 
					,[program_full_name] 
					,[program_short_name] 
					,[program_id_number] 
					,[available_from_date] 
					,[program_end_date] 
					,[program_created_date] 
					,[program_category_id] 
					,[program_category_name] 
					,[program_category_path] 
					,[DWHBatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperation] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[program_id] 
					,src.[program_full_name] 
					,src.[program_short_name] 
					,src.[program_id_number] 
					,src.[available_from_date] 
					,src.[program_end_date] 
					,src.[program_created_date] 
					,src.[program_category_id] 
					,src.[program_category_name] 
					,src.[program_category_path] 
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[program_id],inserted.[program_id]), $action As [MergeAction] into #SummaryOfChanges;

			-- Insert new versions of previously updated records (Updates and Deletes)
			insert into [edw].[dim_program]
			(
				 [program_id] 
				,[program_full_name] 
				,[program_short_name] 
				,[program_id_number] 
				,[available_from_date] 
				,[program_end_date] 
				,[program_created_date] 
				,[program_category_id] 
				,[program_category_name] 
				,[program_category_path] 
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
			)
			select
				 src.[program_id] 
				,src.[program_full_name] 
				,src.[program_short_name] 
				,src.[program_id_number] 
				,src.[available_from_date] 
				,src.[program_end_date] 
				,src.[program_created_date] 
				,src.[program_category_id] 
				,src.[program_category_name] 
				,src.[program_category_path] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLdim_program]'
				,'U'
			from #SummaryOfChanges as base
			inner join [Staging].[ODSETLdim_program] as src on src.[program_id] = base.[program_id]
			where base.[MergeAction] = 'UPDATE'

			union all 

			select
				 tbl.[program_id] 
				,tbl.[program_full_name] 
				,tbl.[program_short_name] 
				,tbl.[program_id_number] 
				,tbl.[available_from_date] 
				,tbl.[program_end_date] 
				,tbl.[program_created_date] 
				,tbl.[program_category_id] 
				,tbl.[program_category_name] 
				,tbl.[program_category_path] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLdim_program]'
				,'D'
			from #SummaryOfChanges as base
			inner join [edw].[dim_program] as tbl on tbl.[program_id] = base.[program_id] and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			left join [Staging].[ODSETLdim_program] as src on src.[program_id] = base.[program_id]
			where base.[MergeAction] = 'UPDATE'
			and  src.[program_id] is null;
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[dim_program]
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