





create procedure [edw].[update_edw_dim_age_group] 
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
	declare @SourceSystem nvarchar(120) = '[edw].[dim_age_group]';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	truncate table [edw].[dim_age_group];

	-- Do not run if there are records in source
	select @stagedRecords = count(1) from [staging].[dim_age_group];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[dim_age_group];

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
		
		-- Re-insert all records
			insert into [edw].[dim_age_group]
		(
      [age_in_years]
      ,[age_group_tangatawhaiora]
      ,[age_5_Year_Groups]
      ,[age_decade_Group]
      ,[age_Group_Broad]
      ,[age_Group_MoH_Covid]
      ,[age_group_groupings]
      ,[DWHSourceSystem]
      ,[DWHCreatedAt]
      ,[DWHBatchId]
		)
		select
				 src.[age_in_years]
				,src.[age_group_tangatawhaiora]
				,src.[age_5_Year_Groups] 
				,src.[age_decade_Group] 
				,src.[age_Group_Broad] 
				,src.[age_Group_MoH_Covid] 
				,src.[age_group_groupings] 
				,@SourceSystem as [DWHSourceSystem]
				,getdate() as [DWHCreatedAt]
				,@BatchID as [DWHBatchId]
		from [Staging].[dim_age_group] as src;
		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = 0
		from [EDW].[dim_age_group];

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