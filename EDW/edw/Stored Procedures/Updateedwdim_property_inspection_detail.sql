
CREATE procedure [edw].[Updateedwdim_property_inspection_detail] 

/***************************************************************************
NAME:     [edw].[Updateedwdim_property_inspection_detail]
PURPOSE:  

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2026-08-03    Greg Nuthall		Initial version
****************************************************************************/

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
	declare @SourceSystem nvarchar(120) = 'vw_zav_inspectiondetail, vw_StateMetadata';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	-- Do not run if there are records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLdim_property_inspection_detail];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[dim_property_inspection_detail];

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
		if( not exists (select top(1) 1 from [edw].[dim_property_inspection_detail]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[dim_property_inspection_detail]
			(    [dim_property_key]
				,[property_id] 
				,[property_inspection_detail_id] 
				,[asset_condition_id] 
				,[asset_condition] 
				,[property_is_clean] 
				,[inspection_comments] 
				,[property_inspection_id] 
				,[property_undamaged] 
				,[property_working] 
				,[asset_name] 
				,[inspection_area] 
				,[property_asset_name] 
				,[EDWBatchId] 
				,[EDWCreatedAt] 
				,[EDWModifiedOn] 
				,[EDWDMLOperation] 
				,[EDWSourceSystem] 
			)
			select
			     src.dim_property_key
				,src.[property_id] 
				,src.[property_inspection_detail_id] 
				,src.[asset_condition_id] 
				,src.[asset_condition] 
				,src.[property_is_clean] 
				,src.[inspection_comments] 
				,src.[property_inspection_id] 
				,src.[property_undamaged] 
				,src.[property_working] 
				,src.[asset_name] 
				,src.[inspection_area] 
				,src.[property_asset_name] 
				,@BatchID as [EDWBatchId]
				,getdate() as [EDWCreatedAt]
				,getdate() as [EDWModifiedOn]
				,'I' as [EDWDMLOperation]
				,@SourceSystem as [EDWSourceSystem]
			from [Staging].[ODSETLdim_property_inspection_detail] as src;
		end else begin
			merge into [edw].[dim_property_inspection_detail] as trg
			using 
			(
				select
				 src.[dim_property_key]
				,src.[property_id] 
				,src.[property_inspection_detail_id] 
				,src.[asset_condition_id] 
				,src.[asset_condition] 
				,src.[property_is_clean] 
				,src.[inspection_comments] 
				,src.[property_inspection_id] 
				,src.[property_undamaged] 
				,src.[property_working] 
				,src.[asset_name] 
				,src.[inspection_area] 
				,src.[property_asset_name] 
				,@BatchID as [EDWBatchId]
				,getdate() as [EDWCreatedAt]
				,getdate() as [EDWModifiedOn]
				,'I' as [EDWDMLOperation]
				,@SourceSystem as [EDWSourceSystem]
				from [Staging].[ODSETLdim_property_inspection_detail] as src
			) as src on (src.[property_inspection_detail_id] = trg.[property_inspection_detail_id])			-- Retire existing records
			when matched and exists 
			( 
				select src.[property_id], src.[asset_condition_id], src.[asset_condition], src.[property_is_clean], src.[inspection_comments], src.[property_inspection_id], src.[property_undamaged], src.[property_working], src.[asset_name], src.[inspection_area], src.[property_asset_name]
				except
				select trg.[property_id], trg.[asset_condition_id], trg.[asset_condition], trg.[property_is_clean], trg.[inspection_comments], trg.[property_inspection_id], trg.[property_undamaged], trg.[property_working], trg.[asset_name], trg.[inspection_area], trg.[property_asset_name]
			) then  update set 
				 [property_id] = src.[property_id]
				, [property_inspection_detail_id] = src.[property_inspection_detail_id]
				, [asset_condition_id] = src.[asset_condition_id]
				, [asset_condition] = src.[asset_condition]
				, [property_is_clean] = src.[property_is_clean]
				, [inspection_comments] = src.[inspection_comments]
				, [property_inspection_id] = src.[property_inspection_id]
				, [property_undamaged] = src.[property_undamaged]
				, [property_working] = src.[property_working]
				, [asset_name] = src.[asset_name]
				, [inspection_area] = src.[inspection_area]
				, [property_asset_name] = src.[property_asset_name]
				,[EDWModifiedOn] = @systemCurrentDate
				,[EDWBatchId] = @BatchID
				,[EDWDMLOperation] = isnull(nullif(src.[EDWDMLOperation],'I'),'U')
			-- Soft delete missing records
			when not matched by source and trg.[EDWDMLOperation] <> 'D' then update set [EDWModifiedOn] = @systemCurrentDate, [EDWDMLOperation] = 'D'
			-- Insert new records
			when not matched by target then 
				insert 
				(    [dim_property_key]
					,[property_id] 
					,[property_inspection_detail_id] 
					,[asset_condition_id] 
					,[asset_condition] 
					,[property_is_clean] 
					,[inspection_comments] 
					,[property_inspection_id] 
					,[property_undamaged] 
					,[property_working] 
					,[asset_name] 
					,[inspection_area] 
					,[property_asset_name] 
					,[EDWBatchId] 
					,[EDWCreatedAt] 
					,[EDWModifiedOn] 
					,[EDWDMLOperation] 
					,[EDWSourceSystem] 
				)
				values
				(    src.[dim_property_key]
					,src.[property_id] 
					,src.[property_inspection_detail_id] 
					,src.[asset_condition_id] 
					,src.[asset_condition] 
					,src.[property_is_clean] 
					,src.[inspection_comments] 
					,src.[property_inspection_id] 
					,src.[property_undamaged] 
					,src.[property_working] 
					,src.[asset_name] 
					,src.[inspection_area] 
					,src.[property_asset_name] 
					,src.[EDWBatchId] 
					,src.[EDWCreatedAt] 
					,src.[EDWModifiedOn] 
					,src.[EDWDMLOperation] 
					,src.[EDWSourceSystem] 
				);
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [EDWDMLOperation] = 'I' and [EDWBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [EDWDMLOperation] = 'U' and [EDWBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords = sum( case when [EDWDMLOperation] = 'D' and [EDWBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[dim_property_inspection_detail];

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