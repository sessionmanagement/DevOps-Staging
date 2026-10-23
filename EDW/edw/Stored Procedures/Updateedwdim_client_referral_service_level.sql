CREATE procedure [edw].[Updateedwdim_client_referral_service_level] 

/***************************************************************************
NAME:     [edw].[Updateedwdim_client_referral_service_level]
PURPOSE:  
NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-05-29    Greg Nuthall		Initial version
1.1		 2025-06-30	   Greg Nuthall		Added effective_date and changed to get just the latest record per referral
****************************************************************************/

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
	declare @SourceSystem nvarchar(120) = 'dl.fact_referral_service_level';
	
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
	select @stagedRecords = count(1) from [Staging].[ODSETLdim_client_referral_service_level];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[dim_client_referral_service_level];

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
		 [client_referral_service_level_id] int null
		,[MergeAction] varchar(10)
	);
	begin transaction;

	begin try
		if( not exists (select top(1) 1 from [edw].[dim_client_referral_service_level]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[dim_client_referral_service_level]
			(  
				 dim_client_key
				,dim_client_referral_key
				,[client_referral_service_level_id] 
				,[company_id] 
				,[client_id] 
				,[client_referral_id] 
				,[service_level_code] 
				,[service_level] 
				,[effective_date]
				,[service_level_group]
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperationField] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
			)
			select
				 
				 src.dim_client_key
				,src.dim_client_referral_key
				,src.[client_referral_service_level_id]
				,src.[company_id] 
				,src.[client_id] 
				,src.[client_referral_id] 
				,src.[service_level_code] 
				,src.[service_level] 
				,src.[effective_date]
				,src.[service_level_group]
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperationField]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLdim_client_referral_service_level] as src;
		end else begin
			merge into [edw].[dim_client_referral_service_level] as trg
			using 
			(
				select
				 src.dim_client_key
				,src.dim_client_referral_key
				,src.[client_referral_service_level_id]
				,src.[company_id] 
				,src.[client_id] 
				,src.[client_referral_id] 
				,src.[service_level_code] 
				,src.[service_level] 
				,cast(src.[effective_date] as date) as effective_date
				,src.[service_level_group]
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperationField]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLdim_client_referral_service_level] as src
			) as src on (src.[client_referral_service_level_id] = trg.[client_referral_service_level_id] and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
				select src.[company_id]
					, src.[client_id]
					, src.[client_referral_id]
					, src.[service_level_code]
					, src.[service_level]
					, src.[effective_date]
					, src.[service_level_group]
					
					, case when trg.[DWHDMLOperationField] = 'D' then 'U' else 'X' end
				except
				select trg.[company_id]
					, trg.[client_id]
					, trg.[client_referral_id]
					, trg.[service_level_code]
					, trg.[service_level]
					, trg.[effective_date]
					, trg.[service_level_group]
					, 'X'
			) then  update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Soft delete missing records
			when not matched by source and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo and trg.[DWHDMLOperationField] <> 'D' then update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 dim_client_key
					,dim_client_referral_key
					,client_referral_service_level_id
					,[company_id] 
					,[client_id] 
					,[client_referral_id] 
					,[service_level_code] 
					,[service_level] 
					,[effective_date]
					,[service_level_group]
					,[DWHBatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperationField] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 
				)
				values
				(
					 
					src.dim_client_key
					,src.dim_client_referral_key
					,src.[client_referral_service_level_id] 
					,src.[company_id] 
					,src.[client_id] 
					,src.[client_referral_id] 
					,src.[service_level_code] 
					,src.[service_level] 
					,src.[effective_date]
					,src.[service_level_group]
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperationField] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[client_referral_service_level_id],inserted.[client_referral_service_level_id]), $action As [MergeAction] into #SummaryOfChanges;

			-- Insert new versions of previously updated records (Updates and Deletes)
			insert into [edw].[dim_client_referral_service_level]
			(
				  
				 dim_client_key
				,dim_client_referral_key
				,[client_referral_service_level_id]
				,[company_id] 
				,[client_id] 
				,[client_referral_id] 
				,[service_level_code] 
				,[service_level] 
				,[effective_date]
				,[service_level_group]
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperationField]
			)
			select
				 src.dim_client_key
				,src.dim_client_referral_key
				,src.[client_referral_service_level_id]
				,src.[company_id] 
				,src.[client_id] 
				,src.[client_referral_id] 
				,src.[service_level_code] 
				,src.[service_level]
				,src.[effective_date]
				,src.[service_level_group]
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,@SourceSystem
				,'U'
			from #SummaryOfChanges as base
			inner join [Staging].[ODSETLdim_client_referral_service_level] as src on src.[client_referral_service_level_id] = base.[client_referral_service_level_id]
			where base.[MergeAction] = 'UPDATE'

			union all 

			select
				 
				tbl.dim_client_key
				,tbl.dim_client_referral_key
				,tbl.[client_referral_service_level_id] 
				,tbl.[company_id] 
				,tbl.[client_id] 
				,tbl.[client_referral_id] 
				,tbl.[service_level_code] 
				,tbl.[service_level]
				,tbl.[effective_date]
				,tbl.[service_level_group]
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,@SourceSystem
				,'D'
			from #SummaryOfChanges as base
			inner join [edw].[dim_client_referral_service_level] as tbl on tbl.[client_referral_service_level_id] = base.[client_referral_service_level_id] and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			left join [Staging].[ODSETLdim_client_referral_service_level] as src on src.[client_referral_service_level_id] = base.[client_referral_service_level_id]
			where base.[MergeAction] = 'UPDATE'
			and  src.[client_referral_service_level_id] is null;
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperationField] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperationField] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperationField] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[dim_client_referral_service_level]
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