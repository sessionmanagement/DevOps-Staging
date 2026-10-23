

/**********************************************************************************************************
 Procedure	[edw].[Updateedwdim_client_absence]
 Author		???
 Created		
 Purpose	Load the 	
			
 Notes: Call By	EDW Pipeline '30_Load_From_ODS'
	
 =========================================================================================================

REVISIONS:
Version	 Date			Author			    Description
-------	------------	------------------	--------------------------
1.0		?				?					Initial creation of stored procedure
1.1        2025-05-06     Manish Singh   Changed Prefix of Audit columns from EDW to DWH
**********************************************************************************************************/
CREATE procedure [edw].[Updateedwdim_client_absence] 
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
	declare @SourceSystem nvarchar(120) = '[ETL].[dim_client_absence]';
	
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
	select @stagedRecords = count(1) from [Staging].[ODSETLdim_client_absence];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[dim_client_absence];

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
		 [company_id] int not null
		,[client_id] int null
		,[dim_client_key] int null
		,[client_absence_start_date_time] datetime null
		,[client_absence_end_date_time] datetime null
		,[client_absence_reason_id] int null
		,[MergeAction] varchar(10)
	);
	begin transaction;

	begin try
		if( not exists (select top(1) 1 from [edw].[dim_client_absence]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[dim_client_absence]
			(
				 [company_id] 
				,[dim_client_unique_key] 
				,[client_id]
				,[dim_client_key]
				,[client_absence_approved_by_funder_flag] 
				,[client_absence_start_date_time] 
				,[client_absence_end_date_time] 
				,[client_absence_type] 
				,[client_absence_reason_id] 
				,[client_absence_reason] 
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
			)
			select
				 src.[company_id] 
				,src.[dim_client_unique_key] 
				,src.[client_id] 
				,isnull(dc.[dim_client_key], CASE WHEN src.client_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_client_key]
				,src.[client_absence_approved_by_funder_flag] 
				,src.[client_absence_start_date_time] 
				,src.[client_absence_end_date_time] 
				,src.[client_absence_type] 
				,src.[client_absence_reason_id] 
				,src.[client_absence_reason] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLdim_client_absence] as src
			LEFT JOIN [edw].[dim_client] dc ON src.client_id = dc.client_id
				AND CONVERT(DATETIME, cast(src.client_absence_start_date_time AS nvarchar)) BETWEEN dc.DWHEffectiveFrom
					AND dc.DWHEffectiveTo
				AND src.[company_id] = dc.[company_id];
		end else begin
			merge into [edw].[dim_client_absence] as trg
			using 
			(
				select
				 src.[company_id] 
				,src.[dim_client_unique_key] 
				,src.[client_id] 
				,isnull(dc.[dim_client_key], CASE WHEN src.client_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_client_key]
				,src.[client_absence_approved_by_funder_flag] 
				,src.[client_absence_start_date_time] 
				,src.[client_absence_end_date_time] 
				,src.[client_absence_type] 
				,src.[client_absence_reason_id] 
				,src.[client_absence_reason] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLdim_client_absence] as src
				LEFT JOIN [edw].[dim_client] dc ON src.client_id = dc.client_id
				AND CONVERT(DATETIME, cast(src.client_absence_start_date_time AS nvarchar)) BETWEEN dc.DWHEffectiveFrom
					AND dc.DWHEffectiveTo
				AND src.[company_id] = dc.[company_id]
			) as src on (src.[dim_client_unique_key] = trg.[dim_client_unique_key] and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
				select src.[dim_client_unique_key], src.[client_absence_approved_by_funder_flag], src.[client_absence_type], src.[client_absence_reason], case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
				except
				select trg.[dim_client_unique_key], trg.[client_absence_approved_by_funder_flag], trg.[client_absence_type], trg.[client_absence_reason], 'X'
			) then  update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Soft delete missing records
			when not matched by source and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo and trg.[DWHDMLOperation] <> 'D' then update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [company_id] 
					,[dim_client_unique_key] 
					,[client_id] 
					,[dim_client_key]
					,[client_absence_approved_by_funder_flag] 
					,[client_absence_start_date_time] 
					,[client_absence_end_date_time] 
					,[client_absence_type] 
					,[client_absence_reason_id] 
					,[client_absence_reason] 
					,[DWHBatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperation] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[company_id] 
					,src.[dim_client_unique_key] 
					,src.[client_id] 
					,src.[dim_client_key]
					,src.[client_absence_approved_by_funder_flag] 
					,src.[client_absence_start_date_time] 
					,src.[client_absence_end_date_time] 
					,src.[client_absence_type] 
					,src.[client_absence_reason_id] 
					,src.[client_absence_reason] 
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[company_id],inserted.[company_id]), coalesce(src.[client_id],inserted.[client_id]), coalesce(src.[dim_client_key],inserted.[dim_client_key]), coalesce(src.[client_absence_start_date_time],inserted.[client_absence_start_date_time]), coalesce(src.[client_absence_end_date_time],inserted.[client_absence_end_date_time]), coalesce(src.[client_absence_reason_id],inserted.[client_absence_reason_id]), $action As [MergeAction] into #SummaryOfChanges;

			-- Insert new versions of previously updated records (Updates and Deletes)
			insert into [edw].[dim_client_absence]
			(
				 [company_id] 
				,[dim_client_unique_key] 
				,[client_id] 
				,[dim_client_key]
				,[client_absence_approved_by_funder_flag] 
				,[client_absence_start_date_time] 
				,[client_absence_end_date_time] 
				,[client_absence_type] 
				,[client_absence_reason_id] 
				,[client_absence_reason] 
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
			)
			select
				 src.[company_id] 
				,src.[dim_client_unique_key] 
				,src.[client_id]
				,base.[dim_client_key]
				,src.[client_absence_approved_by_funder_flag] 
				,src.[client_absence_start_date_time] 
				,src.[client_absence_end_date_time] 
				,src.[client_absence_type] 
				,src.[client_absence_reason_id] 
				,src.[client_absence_reason] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLdim_client_absence]'
				,'U'
			from #SummaryOfChanges as base
			inner join [Staging].[ODSETLdim_client_absence] as src on src.[company_id] = base.[company_id] and src.[client_id] = base.[client_id] and src.[client_absence_start_date_time] = base.[client_absence_start_date_time] and src.[client_absence_end_date_time] = base.[client_absence_end_date_time] and src.[client_absence_reason_id] = base.[client_absence_reason_id]
			where base.[MergeAction] = 'UPDATE'

			union all 

			select
				 tbl.[company_id] 
				,tbl.[dim_client_unique_key] 
				,tbl.[client_id]
				,tbl.[dim_client_key]
				,tbl.[client_absence_approved_by_funder_flag] 
				,tbl.[client_absence_start_date_time] 
				,tbl.[client_absence_end_date_time] 
				,tbl.[client_absence_type] 
				,tbl.[client_absence_reason_id] 
				,tbl.[client_absence_reason] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLdim_client_absence]'
				,'D'
			from #SummaryOfChanges as base
			inner join [edw].[dim_client_absence] as tbl on tbl.[company_id] = base.[company_id] and tbl.[client_id] = base.[client_id] and tbl.[client_absence_start_date_time] = base.[client_absence_start_date_time] and tbl.[client_absence_end_date_time] = base.[client_absence_end_date_time] and tbl.[client_absence_reason_id] = base.[client_absence_reason_id] and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			left join [Staging].[ODSETLdim_client_absence] as src on src.[company_id] = base.[company_id] and src.[client_id] = base.[client_id] and src.[client_absence_start_date_time] = base.[client_absence_start_date_time] and src.[client_absence_end_date_time] = base.[client_absence_end_date_time] and src.[client_absence_reason_id] = base.[client_absence_reason_id]
			where base.[MergeAction] = 'UPDATE'
			and  src.[company_id] is null and src.[client_id] is null and src.[client_absence_start_date_time] is null and src.[client_absence_end_date_time] is null and src.[client_absence_reason_id] is null;
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[dim_client_absence]
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