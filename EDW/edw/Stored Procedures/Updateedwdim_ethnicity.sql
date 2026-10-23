

CREATE procedure [edw].[Updateedwdim_ethnicity] 

/**********************************************************************************************************
 Procedure	[edw].[Updateedwdim_ethnicity]
 Author		Glenn McLeod
 Created	2023-12-07	
 Purpose	Move the dim_ethnicity data from staging to the EDW	using SCD2 logic
 Type		SCD2 
 
 Notes: Call By	EDW Pipeline '30_Load_From_ODS'
 =========================================================================================================

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2023-12-07	  Glenn McLeod			Initial version
1.1		2025-04-09	  Greg Nuthall		    Added isnull to the 'when matched and exists' clause so it does not mark records as 'D'
1.3        2025-05-06     Manish Singh   Changed Prefix of Audit columns from EDW to DWH

**********************************************************************************************************/

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
	declare @SourceSystem nvarchar(120) = '[ETL].[dim_ethnicity]';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	-- Do not run if there are records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLdim_ethnicity];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[dim_ethnicity];

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

		IF (
					NOT EXISTS (
						SELECT 1
						FROM [edw].[dim_ethnicity]
						WHERE dim_ethnicity_key <= 0
						)
					)
			BEGIN
				-- turn the identity insert on 
				SET IDENTITY_INSERT [edw].[dim_ethnicity] ON

				INSERT INTO [edw].[dim_ethnicity] (
                     [dim_ethnicity_key]
					,[dim_ethnicity_id]
					,[ethnicity_group]
					,[ethnicity_level1]
					,[ethnicity_level2]
					,[ethnicity_level3]
					,[ethnicity_level4]
					,[ethnicity_level5]
					,[DWHSourceSystem] 
					,[DWHBatchId] 
					,[DWHDMLOperation] 
					,[DWHCreatedAt] 
					,[DWHModifiedOn] 
					)
				VALUES 
					(
					0
					,'N/A'
					,'N/A'
					,'N/A'
					,'N/A'
					,'N/A'
					,'N/A'
					,'N/A'
					,@SourceSystem
					,0
					,'I'
					,@systemCurrentDate
					,@systemCurrentDate
					),
					(
					-1
					,'Unknown'
					,'Unknown'
					,'Unknown'
					,'Unknown'
					,'Unknown'
					,'Unknown'
					,'Unknown'
					,@SourceSystem
					,0
					,'I'
					,@systemCurrentDate
					,@systemCurrentDate
					)

				-- turn the identity insert off
				SET IDENTITY_INSERT [edw].[dim_ethnicity] OFF
			END




		if( not exists (select top(1) 1 from [edw].[dim_ethnicity]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[dim_ethnicity]
			(
				 [dim_ethnicity_id] 
				,[ethnicity_group] 
				,[ethnicity_level1] 
				,[ethnicity_level2] 
				,[ethnicity_level3] 
				,[ethnicity_level4] 
				,[ethnicity_level5] 
				,[DWHBatchId] 
				,[DWHCreatedAt] 
				,[DWHModifiedOn] 
				,[DWHDMLOperation] 
				,[DWHSourceSystem] 
			)
			select
				 src.[dim_ethnicity_id] 
				,src.[ethnicity_group] 
				,src.[ethnicity_level1] 
				,src.[ethnicity_level2] 
				,src.[ethnicity_level3] 
				,src.[ethnicity_level4] 
				,src.[ethnicity_level5] 
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLdim_ethnicity] as src;
		end else begin
			merge into [edw].[dim_ethnicity] as trg
			using 
			(
				select
				 src.[dim_ethnicity_id] 
				,src.[ethnicity_group] 
				,src.[ethnicity_level1] 
				,src.[ethnicity_level2] 
				,src.[ethnicity_level3] 
				,src.[ethnicity_level4] 
				,src.[ethnicity_level5] 
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLdim_ethnicity] as src
			) as src on (src.[dim_ethnicity_id] = trg.[dim_ethnicity_id] collate database_default)			-- Retire existing records
			when matched and exists 
			( 
				select src.[ethnicity_group], src.[ethnicity_level1], isnull(src.[ethnicity_level2],''), isnull(src.[ethnicity_level3],''), isnull(src.[ethnicity_level4],''), isnull(src.[ethnicity_level5],'')
				except
				select trg.[ethnicity_group], trg.[ethnicity_level1], isnull(trg.[ethnicity_level2],''), isnull(trg.[ethnicity_level3],''), isnull(trg.[ethnicity_level4],''), isnull(trg.[ethnicity_level5],'')
			) then  update set 
				 [dim_ethnicity_id] = src.[dim_ethnicity_id]
				, [ethnicity_group] = src.[ethnicity_group]
				, [ethnicity_level1] = src.[ethnicity_level1]
				, [ethnicity_level2] = src.[ethnicity_level2]
				, [ethnicity_level3] = src.[ethnicity_level3]
				, [ethnicity_level4] = src.[ethnicity_level4]
				, [ethnicity_level5] = src.[ethnicity_level5]
				,[DWHModifiedOn] = @systemCurrentDate
				,[DWHBatchId] = @BatchID
				,[DWHDMLOperation] = isnull(nullif(src.[DWHDMLOperation],'I'),'U')
			-- Soft delete missing records
			when not matched by source 
			and trg.[dim_ethnicity_key] > 0
			and trg.[DWHDMLOperation] <> 'D' 
			then update set [DWHModifiedOn] = @systemCurrentDate, [DWHDMLOperation] = 'D'
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [dim_ethnicity_id] 
					,[ethnicity_group] 
					,[ethnicity_level1] 
					,[ethnicity_level2] 
					,[ethnicity_level3] 
					,[ethnicity_level4] 
					,[ethnicity_level5] 
					,[DWHBatchId] 
					,[DWHCreatedAt] 
					,[DWHModifiedOn] 
					,[DWHDMLOperation] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[dim_ethnicity_id] 
					,src.[ethnicity_group] 
					,src.[ethnicity_level1] 
					,src.[ethnicity_level2] 
					,src.[ethnicity_level3] 
					,src.[ethnicity_level4] 
					,src.[ethnicity_level5] 
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
		from [edw].[dim_ethnicity];

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