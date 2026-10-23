
CREATE procedure [edw].[Updateedwfact_property_tribunal_order] 

--=========================================================================================================
--Procedure		[edw].[Updateedwfact_property_tribunal_order] 
--Author		Greg Nuthall
--Created		2025-07-15
--Purpose		property tribunal order from vw_zav_tribunalorder to generate fact_property_tribunal_order
				
--=========================================================================================================
--REVISIONS:
--Version	 Date		   Author			Description
---------	 ------------  ---------------	--------------------------
--1.0		 2025-07-15    Greg Nuthall		Initial version
----------------------------------------------------------------------



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
	declare @SourceSystem nvarchar(120) = 'Zavanti.vw_zav_tribunalorder';
	
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
	select @stagedRecords = count(1) from [Staging].[ODSETLfact_property_tribunal_order];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[fact_property_tribunal_order];

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
		 [property_tribunal_order_id] uniqueidentifier null
		,[MergeAction] varchar(10)
	);
	begin transaction;

	begin try
		if( not exists (select top(1) 1 from [edw].[fact_property_tribunal_order]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[fact_property_tribunal_order]
			(
				 [property_tribunal_order_id] 
				,[property_tenancy_breach_id] 
				,[property_tenancy_id]
				,[property_id]
				,[dim_property_tenancy_key]
				,[dim_property_key]
				,[tribunal_order] 
				,[notes] 
				,[tribunal_outcome] 
				,[tribunal_outcome_reason] 
				,[tribunal_order_start_date] 
				,[tribunal_order_owner] 
				,[modified_by] 
				,[modified_date] 
				,[created_date] 
				,[tribunal_order_state] 
				,[tribunal_order_status] 
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
			)
			select
				 src.[property_tribunal_order_id] 
				,src.[property_tenancy_breach_id]
				,src.[property_tenancy_id]
				,src.[property_id]
				,src.[dim_property_tenancy_key]
				,src.[dim_property_key]
				,src.[tribunal_order] 
				,src.[notes] 
				,src.[tribunal_outcome] 
				,src.[tribunal_outcome_reason] 
				,src.[tribunal_order_start_date] 
				,src.[tribunal_order_owner] 
				,src.[modified_by] 
				,src.[modified_date] 
				,src.[created_date] 
				,src.[tribunal_order_state] 
				,src.[tribunal_order_status] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLfact_property_tribunal_order] as src;
		end else begin
			merge into [edw].[fact_property_tribunal_order] as trg
			using 
			(
				select
				 src.[property_tribunal_order_id] 
				,src.[property_tenancy_breach_id]
				,src.[property_tenancy_id]
				,src.[property_id]
				,src.[dim_property_tenancy_key]
				,src.[dim_property_key]
				,src.[tribunal_order] 
				,src.[notes] 
				,src.[tribunal_outcome] 
				,src.[tribunal_outcome_reason] 
				,src.[tribunal_order_start_date] 
				,src.[tribunal_order_owner] 
				,src.[modified_by] 
				,src.[modified_date] 
				,src.[created_date] 
				,src.[tribunal_order_state] 
				,src.[tribunal_order_status] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLfact_property_tribunal_order] as src
			) as src on (src.[property_tribunal_order_id] = trg.[property_tribunal_order_id] and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
				SELECT src.[property_tenancy_breach_id]
						,isnull(src.[tribunal_order],'')
						,isnull(src.[notes],'')
						,isnull(src.[tribunal_outcome],'')
						,isnull(src.[tribunal_outcome_reason],'')
						,src.[tribunal_order_start_date]
						,src.[tribunal_order_owner]
						,src.[modified_by]
						,src.[modified_date]
						,src.[created_date]
						,isnull(src.[tribunal_order_state],'')
						,isnull(src.[tribunal_order_status],'')
						,CASE 
							WHEN trg.[DWHDMLOperation] = 'D'
								THEN 'U'
							ELSE 'X'
							END

					EXCEPT

					SELECT trg.[property_tenancy_breach_id]
						,isnull(trg.[tribunal_order],'')
						,isnull(trg.[notes],'')
						,isnull(trg.[tribunal_outcome],'')
						,isnull(trg.[tribunal_outcome_reason],'')
						,trg.[tribunal_order_start_date]
						,trg.[tribunal_order_owner]
						,trg.[modified_by]
						,trg.[modified_date]
						,trg.[created_date]
						,isnull(trg.[tribunal_order_state],'')
						,isnull(trg.[tribunal_order_status],'')
						,'X'
	
	) then  update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Soft delete missing records
			when not matched by source and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo and trg.[DWHDMLOperation] <> 'D' then update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [property_tribunal_order_id] 
					,[property_tenancy_breach_id] 
					,[property_tenancy_id]
					,[property_id]
					,[dim_property_tenancy_key]
					,[dim_property_key]
					,[tribunal_order] 
					,[notes] 
					,[tribunal_outcome] 
					,[tribunal_outcome_reason] 
					,[tribunal_order_start_date] 
					,[tribunal_order_owner] 
					,[modified_by] 
					,[modified_date] 
					,[created_date] 
					,[tribunal_order_state] 
					,[tribunal_order_status] 
					,[DWHBatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperation] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[property_tribunal_order_id] 
					,src.[property_tenancy_breach_id] 
					,src.[property_tenancy_id]
					,src.[property_id]
					,src.[dim_property_tenancy_key]
					,src.[dim_property_key]
					,src.[tribunal_order] 
					,src.[notes] 
					,src.[tribunal_outcome] 
					,src.[tribunal_outcome_reason] 
					,src.[tribunal_order_start_date] 
					,src.[tribunal_order_owner] 
					,src.[modified_by] 
					,src.[modified_date] 
					,src.[created_date] 
					,src.[tribunal_order_state] 
					,src.[tribunal_order_status] 
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[property_tribunal_order_id],inserted.[property_tribunal_order_id]), $action As [MergeAction] into #SummaryOfChanges;

			-- Insert new versions of previously updated records (Updates and Deletes)
			insert into [edw].[fact_property_tribunal_order]
			(
				 [property_tribunal_order_id] 
				,[property_tenancy_breach_id] 
				,[property_tenancy_id]
				,[property_id]
				,[dim_property_tenancy_key]
				,[dim_property_key]
				,[tribunal_order] 
				,[notes] 
				,[tribunal_outcome] 
				,[tribunal_outcome_reason] 
				,[tribunal_order_start_date] 
				,[tribunal_order_owner] 
				,[modified_by] 
				,[modified_date] 
				,[created_date] 
				,[tribunal_order_state] 
				,[tribunal_order_status] 
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
			)
			select
				 src.[property_tribunal_order_id] 
				,src.[property_tenancy_breach_id]
				,src.[property_tenancy_id]
				,src.[property_id]
				,src.[dim_property_tenancy_key]
				,src.[dim_property_key]
				,src.[tribunal_order] 
				,src.[notes] 
				,src.[tribunal_outcome] 
				,src.[tribunal_outcome_reason] 
				,src.[tribunal_order_start_date] 
				,src.[tribunal_order_owner] 
				,src.[modified_by] 
				,src.[modified_date] 
				,src.[created_date] 
				,src.[tribunal_order_state] 
				,src.[tribunal_order_status] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,@SourceSystem
				,'U'
			from #SummaryOfChanges as base
			inner join [Staging].[ODSETLfact_property_tribunal_order] as src on src.[property_tribunal_order_id] = base.[property_tribunal_order_id]
			where base.[MergeAction] = 'UPDATE'

			union all 

			select
				 tbl.[property_tribunal_order_id] 
				,tbl.[property_tenancy_breach_id] 
				,tbl.[property_tenancy_id]
				,tbl.[property_id]
				,tbl.[dim_property_tenancy_key]
				,tbl.[dim_property_key]
				,tbl.[tribunal_order] 
				,tbl.[notes] 
				,tbl.[tribunal_outcome] 
				,tbl.[tribunal_outcome_reason] 
				,tbl.[tribunal_order_start_date] 
				,tbl.[tribunal_order_owner] 
				,tbl.[modified_by] 
				,tbl.[modified_date] 
				,tbl.[created_date] 
				,tbl.[tribunal_order_state] 
				,tbl.[tribunal_order_status] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,@SourceSystem
				,'D'
			from #SummaryOfChanges as base
			inner join [edw].[fact_property_tribunal_order] as tbl on tbl.[property_tribunal_order_id] = base.[property_tribunal_order_id] and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			left join [Staging].[ODSETLfact_property_tribunal_order] as src on src.[property_tribunal_order_id] = base.[property_tribunal_order_id]
			where base.[MergeAction] = 'UPDATE'
			and  src.[property_tribunal_order_id] is null;
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[fact_property_tribunal_order]
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