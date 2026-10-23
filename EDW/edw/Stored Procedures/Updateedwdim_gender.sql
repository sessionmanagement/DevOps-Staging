



/**********************************************************************************************************
 Procedure	[edw].[Updateedwdim_gender]
 Author		
 Created		
 Purpose		
				

				
 Notes: Call By	EDW Pipeline '30_Load_From_ODS'
	
 =========================================================================================================

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2023-12-04	  Glenn McLeod			Initial version
1.3        2025-05-06     Manish Singh   Changed Prefix of Audit columns from EDW to DWH


**********************************************************************************************************/

CREATE procedure [edw].[Updateedwdim_gender] 
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
	declare @SourceSystem nvarchar(120) = '[ETL].[dim_gender]';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	-- Do not run if there are records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLdim_gender];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[dim_gender];

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
					FROM [edw].[dim_gender]
					WHERE dim_gender_key <= 0
					)
				)
		BEGIN
			-- turn the identity insert on 
			SET IDENTITY_INSERT [edw].[dim_gender] ON

			INSERT INTO [edw].[dim_gender] (
				[dim_gender_key]
				,[gender_id]
				,[gender_code]
				,[gender_name]
				,[intellihr_gender_key]
				,[datapay_gender_key]
				,[zavanti_gender_key]
				,[emplive_gender_key]
				,[DWHSourceSystem] 
				,[DWHBatchId] 
				,[DWHDMLOperation] 
				,[DWHCreatedAt] 
				,[DWHModifiedOn] 
				)
			VALUES 
				(
				0
				,0
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
				,-1
				,'Unk'
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
			SET IDENTITY_INSERT [edw].[dim_gender] OFF
		END


		if( not exists (select top(1) 1 from [edw].[dim_gender]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[dim_gender]
			(
				 [gender_id] 
				,[gender_code] 
				,[gender_name] 
				,[intellihr_gender_key] 
				,[datapay_gender_key] 
				,[zavanti_gender_key] 
				,[emplive_gender_key] 
			, [DWHBatchId]
				, [DWHCreatedAt]
				, [DWHModifiedOn]
				, [DWHDMLOperation]
				, [DWHSourceSystem]
			)
			select
				 src.[gender_id] 
				,src.[gender_code] 
				,src.[gender_name] 
				,src.[intellihr_gender_key] 
				,src.[datapay_gender_key] 
				,src.[zavanti_gender_key] 
				,src.[emplive_gender_key] 
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLdim_gender] as src;
		end else begin
			merge into [edw].[dim_gender] as trg
			using 
			(
				select
				 src.[gender_id] 
				,src.[gender_code] 
				,src.[gender_name] 
				,src.[intellihr_gender_key] 
				,src.[datapay_gender_key] 
				,src.[zavanti_gender_key] 
				,src.[emplive_gender_key] 
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLdim_gender] as src
			) as src on (src.[gender_id] = trg.[gender_id])			-- Retire existing records
			when matched and exists 
			( 
				select src.[gender_code], src.[gender_name], src.[intellihr_gender_key], src.[datapay_gender_key], src.[zavanti_gender_key], src.[emplive_gender_key]
				except
				select trg.[gender_code], trg.[gender_name], trg.[intellihr_gender_key], trg.[datapay_gender_key], trg.[zavanti_gender_key], trg.[emplive_gender_key]
			) then  update set 
				 [gender_id] = src.[gender_id]
				, [gender_code] = src.[gender_code]
				, [gender_name] = src.[gender_name]
				, [intellihr_gender_key] = src.[intellihr_gender_key]
				, [datapay_gender_key] = src.[datapay_gender_key]
				, [zavanti_gender_key] = src.[zavanti_gender_key]
				, [emplive_gender_key] = src.[emplive_gender_key]
				,[DWHModifiedOn] = @systemCurrentDate
				,[DWHBatchId] = @BatchID
				,[DWHDMLOperation] = isnull(nullif(src.[DWHDMLOperation],'I'),'U')
			-- Soft delete missing records
			when not matched by source 
				and trg.[dim_gender_key] > 0
				and trg.[DWHDMLOperation] <> 'D' 
			then update set [DWHModifiedOn] = @systemCurrentDate, [DWHDMLOperation] = 'D'
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [gender_id] 
					,[gender_code] 
					,[gender_name] 
					,[intellihr_gender_key] 
					,[datapay_gender_key] 
					,[zavanti_gender_key] 
					,[emplive_gender_key] 
			, [DWHBatchId]
				, [DWHCreatedAt]
				, [DWHModifiedOn]
				, [DWHDMLOperation]
				, [DWHSourceSystem]
				)
				values
				(
					 src.[gender_id] 
					,src.[gender_code] 
					,src.[gender_name] 
					,src.[intellihr_gender_key] 
					,src.[datapay_gender_key] 
					,src.[zavanti_gender_key] 
					,src.[emplive_gender_key] 
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
		from [edw].[dim_gender];

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