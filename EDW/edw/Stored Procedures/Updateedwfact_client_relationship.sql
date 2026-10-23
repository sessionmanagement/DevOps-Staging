
CREATE procedure [edw].[Updateedwfact_client_relationship] 
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
	declare @SourceSystem nvarchar(120) = 'Recordbase dlfactPersonlink, dlFactPersonLinkRelationship';
	
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
	select @stagedRecords = count(1) from [Staging].[ODSETLfact_client_relationship];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[fact_client_relationship];

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
		 [client_relationship_id] int null
		,[MergeAction] varchar(10)
	);
	begin transaction;

	begin try
		if( not exists (select top(1) 1 from [edw].[fact_client_relationship]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[fact_client_relationship]
			(
				 [dim_company_key]
				,[dim_primary_client_key]
				,[dim_related_client_key]
				,[dim_primary_client_unique_key]
				,[dim_related_client_unique_key]
				,[client_relationship_id] 
				,[primary_client_id] 
				,[primary_first_name] 
				,[primary_last_name] 
				,[relationship] 
				,[related_client_id] 
				,[related_first_name] 
				,[related_last_name] 
				,[relationship_start_date] 
				,[relationship_end_date] 
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
			)
			select
				 src.[dim_company_key] 
				,src.[dim_primary_client_key]
				,src.[dim_related_client_key]
				,src.[dim_primary_client_unique_key]
				,src.[dim_related_client_unique_key]
				,src.[client_relationship_id] 
				,src.[primary_client_id] 
				,src.[primary_first_name] 
				,src.[primary_last_name] 
				,src.[relationship] 
				,src.[related_client_id] 
				,src.[related_first_name] 
				,src.[related_last_name] 
				,src.[relationship_start_date] 
				,src.[relationship_end_date] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLfact_client_relationship] as src;
		end else begin
			merge into [edw].[fact_client_relationship] as trg
			using 
			(
				select
				 src.[dim_company_key]
				,src.[dim_primary_client_key]
				,src.[dim_related_client_key]
				,src.[dim_primary_client_unique_key]
				,src.[dim_related_client_unique_key]
				,src.[client_relationship_id] 
				,src.[primary_client_id] 
				,src.[primary_first_name] 
				,src.[primary_last_name] 
				,src.[relationship] 
				,src.[related_client_id] 
				,src.[related_first_name] 
				,src.[related_last_name] 
				,src.[relationship_start_date] 
				,src.[relationship_end_date] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLfact_client_relationship] as src
			) as src on (src.[client_relationship_id] = trg.[client_relationship_id] and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
				select src.[dim_company_key], src.[primary_client_id], src.[primary_first_name], src.[primary_last_name], src.[relationship], src.[related_client_id], src.[related_first_name], src.[related_last_name], src.[relationship_start_date], src.[relationship_end_date], case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
				except
				select trg.[dim_company_key], trg.[primary_client_id], trg.[primary_first_name], trg.[primary_last_name], trg.[relationship], trg.[related_client_id], trg.[related_first_name], trg.[related_last_name], trg.[relationship_start_date], trg.[relationship_end_date], 'X'
			) then  update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Soft delete missing records
			when not matched by source and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo and trg.[DWHDMLOperation] <> 'D' then update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [dim_company_key]
					,[dim_primary_client_key]
					,[dim_related_client_key]
					,[dim_primary_client_unique_key]
					,[dim_related_client_unique_key]
					,[client_relationship_id] 
					,[primary_client_id] 
					,[primary_first_name] 
					,[primary_last_name] 
					,[relationship] 
					,[related_client_id] 
					,[related_first_name] 
					,[related_last_name] 
					,[relationship_start_date] 
					,[relationship_end_date] 
					,[DWHBatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperation] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[dim_company_key]
					,src.[dim_primary_client_key]
					,src.[dim_related_client_key]
					,src.[dim_primary_client_unique_key]
					,src.[dim_related_client_unique_key]
					,src.[client_relationship_id] 
					,src.[primary_client_id] 
					,src.[primary_first_name] 
					,src.[primary_last_name] 
					,src.[relationship] 
					,src.[related_client_id] 
					,src.[related_first_name] 
					,src.[related_last_name] 
					,src.[relationship_start_date] 
					,src.[relationship_end_date] 
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[client_relationship_id],inserted.[client_relationship_id]), $action As [MergeAction] into #SummaryOfChanges;

			-- Insert new versions of previously updated records (Updates and Deletes)
			insert into [edw].[fact_client_relationship]
			(
				 [dim_company_key]
				,[dim_primary_client_key]
				,[dim_related_client_key]
				,[dim_primary_client_unique_key]
				,[dim_related_client_unique_key]
				,[client_relationship_id] 
				,[primary_client_id] 
				,[primary_first_name] 
				,[primary_last_name] 
				,[relationship] 
				,[related_client_id] 
				,[related_first_name] 
				,[related_last_name] 
				,[relationship_start_date] 
				,[relationship_end_date] 
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
			)
			select
				 src.[dim_company_key] 
				,src.[dim_primary_client_key]
				,src.[dim_related_client_key]
				,src.[dim_primary_client_unique_key]
				,src.[dim_related_client_unique_key]
				,src.[client_relationship_id] 
				,src.[primary_client_id] 
				,src.[primary_first_name] 
				,src.[primary_last_name] 
				,src.[relationship] 
				,src.[related_client_id] 
				,src.[related_first_name] 
				,src.[related_last_name] 
				,src.[relationship_start_date] 
				,src.[relationship_end_date] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,@SourceSystem
				,'U'
			from #SummaryOfChanges as base
			inner join [Staging].[ODSETLfact_client_relationship] as src on src.[client_relationship_id] = base.[client_relationship_id]
			where base.[MergeAction] = 'UPDATE'

			union all 

			select
				 tbl.[dim_company_key]
				,tbl.[dim_primary_client_key]
				,tbl.[dim_related_client_key]
				,tbl.[dim_primary_client_unique_key]
				,tbl.[dim_related_client_unique_key]
				,tbl.[client_relationship_id] 
				,tbl.[primary_client_id] 
				,tbl.[primary_first_name] 
				,tbl.[primary_last_name] 
				,tbl.[relationship] 
				,tbl.[related_client_id] 
				,tbl.[related_first_name] 
				,tbl.[related_last_name] 
				,tbl.[relationship_start_date] 
				,tbl.[relationship_end_date] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,@SourceSystem
				,'D'
			from #SummaryOfChanges as base
			inner join [edw].[fact_client_relationship] as tbl on tbl.[client_relationship_id] = base.[client_relationship_id] and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			left join [Staging].[ODSETLfact_client_relationship] as src on src.[client_relationship_id] = base.[client_relationship_id]
			where base.[MergeAction] = 'UPDATE'
			and  src.[client_relationship_id] is null;
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[fact_client_relationship]
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