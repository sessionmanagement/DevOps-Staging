


/**********************************************************************************************************
Procedure	[edw].[Updateedwdim_business_unit_hierarchy] 
Author		Glenn McLeod
Created		2023/12/20

			
				
 Notes: Call By	EDW Pipeline '30_Load_From_ODS'
Parameter(s)  None 
=========================================================================================================
	
REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2023-12-20    Glenn McLeod			Initial creation of stored procedure
1.1        2025-05-06     Manish Singh   Changed Prefix of Audit columns from EDW to DWH


**********************************************************************************************************/


CREATE procedure [edw].[Updateedwdim_business_unit_hierarchy] 
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
	declare @SourceSystem nvarchar(120) = '[ETL].[dim_business_unit_hierarchy]';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	-- Do not run if there are records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLdim_business_unit_hierarchy];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[dim_business_unit_hierarchy];

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
			FROM [edw].[dim_business_unit_hierarchy]
			WHERE dim_business_unit_hierarchy_key <= 0
			)
		)
		BEGIN
			-- turn the identity insert on 
			SET IDENTITY_INSERT [edw].[dim_business_unit_hierarchy] ON

			INSERT INTO [edw].[dim_business_unit_hierarchy] (
				[dim_business_unit_hierarchy_key]
				,[business_unit_id]
				,[business_unit_name]
				,[business_unit_hierarchy_level1_id]
				,[business_unit_hierarchy_level1_name]
				,[business_unit_hierarchy_level2_id]
				,[business_unit_hierarchy_level2_name]
				,[business_unit_hierarchy_level3_id]
				,[business_unit_hierarchy_level3_name]
				,[business_unit_hierarchy_level4_id]
				,[business_unit_hierarchy_level4_name]
				,[business_unit_hierarchy_level5_id]
				,[business_unit_hierarchy_level5_name]
				,[business_unit_hierarchy_level6_id]
				,[business_unit_hierarchy_level6_name]
				,[business_unit_hierarchy_level7_id]
				,[business_unit_hierarchy_level7_name]
				,[business_unit_concatenated_hierarchy]
				,[is_active_flag]
				,[DWHSourceSystem] 
				,[DWHBatchId] 
				,[DWHDMLOperation] 
				,[DWHCreatedAt] 
				,[DWHModifiedOn] 
				)
			VALUES (
				0
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,1
				,@SourceSystem
				,0
				,'I'
				,@systemCurrentDate
				,@systemCurrentDate
				)
				,(
				- 1
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,1
				,@SourceSystem
				,0
				,'I'
				,@systemCurrentDate
				,@systemCurrentDate
				)

			-- turn the identity insert off
			SET IDENTITY_INSERT [edw].[dim_business_unit_hierarchy] OFF
		END





		if( not exists (select top(1) 1 from [edw].[dim_business_unit_hierarchy]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[dim_business_unit_hierarchy]
			(
				 [business_unit_id] 
				,[business_unit_name] 
				,[business_unit_hierarchy_level1_id] 
				,[business_unit_hierarchy_level1_name] 
				,[business_unit_hierarchy_level2_id] 
				,[business_unit_hierarchy_level2_name] 
				,[business_unit_hierarchy_level3_id] 
				,[business_unit_hierarchy_level3_name] 
				,[business_unit_hierarchy_level4_id] 
				,[business_unit_hierarchy_level4_name] 
				,[business_unit_hierarchy_level5_id] 
				,[business_unit_hierarchy_level5_name] 
				,[business_unit_hierarchy_level6_id] 
				,[business_unit_hierarchy_level6_name] 
				,[business_unit_hierarchy_level7_id] 
				,[business_unit_hierarchy_level7_name] 
				,[business_unit_concatenated_hierarchy] 
				,[is_active_flag] 
				,[DWHBatchId] 
				,[DWHCreatedAt] 
				,[DWHModifiedOn] 
				,[DWHDMLOperation] 
				,[DWHSourceSystem] 
			)
			select
				 src.[business_unit_id] 
				,src.[business_unit_name] 
				,src.[business_unit_hierarchy_level1_id] 
				,src.[business_unit_hierarchy_level1_name] 
				,src.[business_unit_hierarchy_level2_id] 
				,src.[business_unit_hierarchy_level2_name] 
				,src.[business_unit_hierarchy_level3_id] 
				,src.[business_unit_hierarchy_level3_name] 
				,src.[business_unit_hierarchy_level4_id] 
				,src.[business_unit_hierarchy_level4_name] 
				,src.[business_unit_hierarchy_level5_id] 
				,src.[business_unit_hierarchy_level5_name] 
				,src.[business_unit_hierarchy_level6_id] 
				,src.[business_unit_hierarchy_level6_name] 
				,src.[business_unit_hierarchy_level7_id] 
				,src.[business_unit_hierarchy_level7_name] 
				,src.[business_unit_concatenated_hierarchy] 
				,src.[is_active_flag] 
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLdim_business_unit_hierarchy] as src;
		end else begin
			merge into [edw].[dim_business_unit_hierarchy] as trg
			using 
			(
				select
				 src.[business_unit_id] 
				,src.[business_unit_name] 
				,src.[business_unit_hierarchy_level1_id] 
				,src.[business_unit_hierarchy_level1_name] 
				,src.[business_unit_hierarchy_level2_id] 
				,src.[business_unit_hierarchy_level2_name] 
				,src.[business_unit_hierarchy_level3_id] 
				,src.[business_unit_hierarchy_level3_name] 
				,src.[business_unit_hierarchy_level4_id] 
				,src.[business_unit_hierarchy_level4_name] 
				,src.[business_unit_hierarchy_level5_id] 
				,src.[business_unit_hierarchy_level5_name] 
				,src.[business_unit_hierarchy_level6_id] 
				,src.[business_unit_hierarchy_level6_name] 
				,src.[business_unit_hierarchy_level7_id] 
				,src.[business_unit_hierarchy_level7_name] 
				,src.[business_unit_concatenated_hierarchy] 
				,src.[is_active_flag] 
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLdim_business_unit_hierarchy] as src
			) as src on (src.[business_unit_id] = trg.[business_unit_id] collate database_default)			-- Retire existing records
			when matched and exists 
			( 
				select src.[business_unit_name], src.[business_unit_hierarchy_level1_id], src.[business_unit_hierarchy_level1_name], src.[business_unit_hierarchy_level2_id], src.[business_unit_hierarchy_level2_name], src.[business_unit_hierarchy_level3_id], src.[business_unit_hierarchy_level3_name], src.[business_unit_hierarchy_level4_id], src.[business_unit_hierarchy_level4_name], src.[business_unit_hierarchy_level5_id], src.[business_unit_hierarchy_level5_name], src.[business_unit_hierarchy_level6_id], src.[business_unit_hierarchy_level6_name], src.[business_unit_hierarchy_level7_id], src.[business_unit_hierarchy_level7_name], src.[business_unit_concatenated_hierarchy], src.[is_active_flag]
				except
				select trg.[business_unit_name], trg.[business_unit_hierarchy_level1_id], trg.[business_unit_hierarchy_level1_name], trg.[business_unit_hierarchy_level2_id], trg.[business_unit_hierarchy_level2_name], trg.[business_unit_hierarchy_level3_id], trg.[business_unit_hierarchy_level3_name], trg.[business_unit_hierarchy_level4_id], trg.[business_unit_hierarchy_level4_name], trg.[business_unit_hierarchy_level5_id], trg.[business_unit_hierarchy_level5_name], trg.[business_unit_hierarchy_level6_id], trg.[business_unit_hierarchy_level6_name], trg.[business_unit_hierarchy_level7_id], trg.[business_unit_hierarchy_level7_name], trg.[business_unit_concatenated_hierarchy], trg.[is_active_flag]
			) then  update set 
				 [business_unit_id] = src.[business_unit_id]
				, [business_unit_name] = src.[business_unit_name]
				, [business_unit_hierarchy_level1_id] = src.[business_unit_hierarchy_level1_id]
				, [business_unit_hierarchy_level1_name] = src.[business_unit_hierarchy_level1_name]
				, [business_unit_hierarchy_level2_id] = src.[business_unit_hierarchy_level2_id]
				, [business_unit_hierarchy_level2_name] = src.[business_unit_hierarchy_level2_name]
				, [business_unit_hierarchy_level3_id] = src.[business_unit_hierarchy_level3_id]
				, [business_unit_hierarchy_level3_name] = src.[business_unit_hierarchy_level3_name]
				, [business_unit_hierarchy_level4_id] = src.[business_unit_hierarchy_level4_id]
				, [business_unit_hierarchy_level4_name] = src.[business_unit_hierarchy_level4_name]
				, [business_unit_hierarchy_level5_id] = src.[business_unit_hierarchy_level5_id]
				, [business_unit_hierarchy_level5_name] = src.[business_unit_hierarchy_level5_name]
				, [business_unit_hierarchy_level6_id] = src.[business_unit_hierarchy_level6_id]
				, [business_unit_hierarchy_level6_name] = src.[business_unit_hierarchy_level6_name]
				, [business_unit_hierarchy_level7_id] = src.[business_unit_hierarchy_level7_id]
				, [business_unit_hierarchy_level7_name] = src.[business_unit_hierarchy_level7_name]
				, [business_unit_concatenated_hierarchy] = src.[business_unit_concatenated_hierarchy]
				, [is_active_flag] = src.[is_active_flag]
				,[DWHModifiedOn] = @systemCurrentDate
				,[DWHBatchId] = @BatchID
				,[DWHDMLOperation] = isnull(nullif(src.[DWHDMLOperation],'I'),'U')
			-- Soft delete missing records
			when not matched by source 
			and trg.[dim_business_unit_hierarchy_key] > 0
			and trg.[DWHDMLOperation] <> 'D' then update set [DWHModifiedOn] = @systemCurrentDate, [DWHDMLOperation] = 'D'
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [business_unit_id] 
					,[business_unit_name] 
					,[business_unit_hierarchy_level1_id] 
					,[business_unit_hierarchy_level1_name] 
					,[business_unit_hierarchy_level2_id] 
					,[business_unit_hierarchy_level2_name] 
					,[business_unit_hierarchy_level3_id] 
					,[business_unit_hierarchy_level3_name] 
					,[business_unit_hierarchy_level4_id] 
					,[business_unit_hierarchy_level4_name] 
					,[business_unit_hierarchy_level5_id] 
					,[business_unit_hierarchy_level5_name] 
					,[business_unit_hierarchy_level6_id] 
					,[business_unit_hierarchy_level6_name] 
					,[business_unit_hierarchy_level7_id] 
					,[business_unit_hierarchy_level7_name] 
					,[business_unit_concatenated_hierarchy] 
					,[is_active_flag] 
					,[DWHBatchId] 
					,[DWHCreatedAt] 
					,[DWHModifiedOn] 
					,[DWHDMLOperation] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[business_unit_id] 
					,src.[business_unit_name] 
					,src.[business_unit_hierarchy_level1_id] 
					,src.[business_unit_hierarchy_level1_name] 
					,src.[business_unit_hierarchy_level2_id] 
					,src.[business_unit_hierarchy_level2_name] 
					,src.[business_unit_hierarchy_level3_id] 
					,src.[business_unit_hierarchy_level3_name] 
					,src.[business_unit_hierarchy_level4_id] 
					,src.[business_unit_hierarchy_level4_name] 
					,src.[business_unit_hierarchy_level5_id] 
					,src.[business_unit_hierarchy_level5_name] 
					,src.[business_unit_hierarchy_level6_id] 
					,src.[business_unit_hierarchy_level6_name] 
					,src.[business_unit_hierarchy_level7_id] 
					,src.[business_unit_hierarchy_level7_name] 
					,src.[business_unit_concatenated_hierarchy] 
					,src.[is_active_flag] 
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
		from [edw].[dim_business_unit_hierarchy];

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