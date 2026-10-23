
CREATE procedure [edw].[Updateedwfact_property_tenancy_breach] 

--=========================================================================================================
--View			[edw].[Updateedwfact_property_tenancy_breach] 
--Author		Greg Nuthall
--Created		2025-07-15
--Purpose		property tenancy breach from vw_zav_tenancybreach to generate fact_property_tenancy_breach
				
--=========================================================================================================
--REVISIONS:
--Version	 Date		   Author			Description
---------	 ------------  ---------------	--------------------------
--1.0		 2025-07-05    Greg Nuthall		Initial version
----------------------------------------------------------------------


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
	declare @SourceSystem nvarchar(120) = 'Zavanti vw_zav_tenancybreach, vw_zav_tribunalorder';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	-- Do not run if there are records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLfact_property_tenancy_breach];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[fact_property_tenancy_breach];

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
		if( not exists (select top(1) 1 from [edw].[fact_property_tenancy_breach]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[fact_property_tenancy_breach]
			(
				 [tenancy_breach_id] 
				,[dim_property_tenancy_key]
				,[property_tenancy_id] 
				,[breach] 
				,[tenancy_breach] 
				,[breach_date] 
				,[breach_id] 
				,[breach_status] 
				,[tribunal_order_id] 
				,[tribunal_order] 
				,[breach_end_date] 
				,[breach_start_date] 
				,[tribunal_outcome_id] 
				,[tribunal_outcome] 
				,[case_number] 
				,[tribunal_outcome_reason] 
				,[DWHBatchId] 
				,[DWHCreatedAt] 
				,[DWHModifiedOn] 
				,[DWHDMLOperation] 
				,[DWHSourceSystem] 
			)
			select
				 src.[tenancy_breach_id] 
				,src.[dim_property_tenancy_key]
				,src.[property_tenancy_id] 
				,src.[breach] 
				,src.[tenancy_breach] 
				,src.[breach_date] 
				,src.[breach_id] 
				,src.[breach_status] 
				,src.[tribunal_order_id] 
				,src.[tribunal_order] 
				,src.[breach_end_date] 
				,src.[breach_start_date] 
				,src.[tribunal_outcome_id] 
				,src.[tribunal_outcome] 
				,src.[case_number] 
				,src.[tribunal_outcome_reason] 
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLfact_property_tenancy_breach] as src;
		end else begin
			merge into [edw].[fact_property_tenancy_breach] as trg
			using 
			(
				select
				 src.[tenancy_breach_id]
				,src.[dim_property_tenancy_key]
				,src.[property_tenancy_id] 
				,src.[breach] 
				,src.[tenancy_breach] 
				,src.[breach_date] 
				,src.[breach_id] 
				,src.[breach_status] 
				,src.[tribunal_order_id] 
				,src.[tribunal_order] 
				,src.[breach_end_date] 
				,src.[breach_start_date] 
				,src.[tribunal_outcome_id] 
				,src.[tribunal_outcome] 
				,src.[case_number] 
				,src.[tribunal_outcome_reason] 
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLfact_property_tenancy_breach] as src
			) as src on (src.[tenancy_breach_id] = trg.[tenancy_breach_id] and isnull(src.[tribunal_order_id],'00000000-0000-0000-0000-000000000000') = isnull(trg.[tribunal_order_id],'00000000-0000-0000-0000-000000000000'))			-- Retire existing records
			when matched and exists 
			(SELECT src.[property_tenancy_id]
					,src.[breach]
					,isnull(src.[tenancy_breach],'')
					,src.[breach_date]
					,src.[breach_id]
					,isnull(src.[breach_status],'')
					,src.[tribunal_order]
					,src.[breach_end_date]
					,src.[breach_start_date]
					,src.[tribunal_outcome_id]
					,isnull(src.[tribunal_outcome],'')
					,isnull(src.[case_number],'')
					,isnull(src.[tribunal_outcome_reason],'')

				EXCEPT

				SELECT trg.[property_tenancy_id]
					,trg.[breach]
					,isnull(trg.[tenancy_breach],'')
					,trg.[breach_date]
					,trg.[breach_id]
					,isnull(trg.[breach_status],'')
					,trg.[tribunal_order]
					,trg.[breach_end_date]
					,trg.[breach_start_date]
					,trg.[tribunal_outcome_id]
					,isnull(trg.[tribunal_outcome],'')
					,isnull(trg.[case_number],'')
					,isnull(trg.[tribunal_outcome_reason] ,'')
			) then  update set 
				 [tenancy_breach_id] = src.[tenancy_breach_id]
				, [dim_property_tenancy_key] = src.[dim_property_tenancy_key] 
				, [property_tenancy_id] = src.[property_tenancy_id]
				, [breach] = src.[breach]
				, [tenancy_breach] = src.[tenancy_breach]
				, [breach_date] = src.[breach_date]
				, [breach_id] = src.[breach_id]
				, [breach_status] = src.[breach_status]
				, [tribunal_order_id] = src.[tribunal_order_id]
				, [tribunal_order] = src.[tribunal_order]
				, [breach_end_date] = src.[breach_end_date]
				, [breach_start_date] = src.[breach_start_date]
				, [tribunal_outcome_id] = src.[tribunal_outcome_id]
				, [tribunal_outcome] = src.[tribunal_outcome]
				, [case_number] = src.[case_number]
				, [tribunal_outcome_reason] = src.[tribunal_outcome_reason]
				,[DWHModifiedOn] = @systemCurrentDate
				,[DWHBatchId] = @BatchID
				,[DWHDMLOperation] = isnull(nullif(src.[DWHDMLOperation],'I'),'U')
			-- Soft delete missing records
			when not matched by source and trg.[DWHDMLOperation] <> 'D' then update set [DWHModifiedOn] = @systemCurrentDate, [DWHDMLOperation] = 'D'
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [tenancy_breach_id]
					,[dim_property_tenancy_key]
					,[property_tenancy_id] 
					,[breach] 
					,[tenancy_breach] 
					,[breach_date] 
					,[breach_id] 
					,[breach_status] 
					,[tribunal_order_id] 
					,[tribunal_order] 
					,[breach_end_date] 
					,[breach_start_date] 
					,[tribunal_outcome_id] 
					,[tribunal_outcome] 
					,[case_number] 
					,[tribunal_outcome_reason] 
					,[DWHBatchId] 
					,[DWHCreatedAt] 
					,[DWHModifiedOn] 
					,[DWHDMLOperation] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[tenancy_breach_id]
					,src.[dim_property_tenancy_key]
					,src.[property_tenancy_id] 
					,src.[breach] 
					,src.[tenancy_breach] 
					,src.[breach_date] 
					,src.[breach_id] 
					,src.[breach_status] 
					,src.[tribunal_order_id] 
					,src.[tribunal_order] 
					,src.[breach_end_date] 
					,src.[breach_start_date] 
					,src.[tribunal_outcome_id] 
					,src.[tribunal_outcome] 
					,src.[case_number] 
					,src.[tribunal_outcome_reason] 
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
		from [edw].[fact_property_tenancy_breach];

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