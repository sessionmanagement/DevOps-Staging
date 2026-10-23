



create procedure [edw].[Updateedwdim_employee_incident_classification] 
	@pBatchID int, 
	@pIndexRebuildThreshold int,
	@pOutputParamsAsDataset int = 0,
	@pErrorRecords int = null OUTPUT, 
	@pInsertRecords int = null OUTPUT, 
	@pUpdateRecords int = null OUTPUT, 
	@pDeleteRecords int = null OUTPUT,
	@pCompleted int = null OUTPUT,
	@pTargetRecords int = null OUTPUT 
as

/***************************************************************************
NAME:     [edw].[Updateedwdim_employee_incident_classification]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2026-01-22    Pankaj Bhatt		Initial version

****************************************************************************/

begin

	set nocount on;
	set xact_abort on;

	-- Variables
	declare @batchID int = @pBatchID;
	declare @SourceSystem nvarchar(120) = 'EcoPortal.incident_investigations';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	-- Do not run if there are records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLdim_employee_incident_classification];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[dim_employee_incident_classification];

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
	
	
	-- insert N/A, Unknown records

	if( not exists (select top(1) 1 from [edw].[dim_employee_incident_classification] where dim_employee_incident_classification_key <= 0) )
		begin
		-- turn the identity insert on 
		   SET IDENTITY_INSERT [edw].[dim_employee_incident_classification] ON

			insert into [edw].[dim_employee_incident_classification]
			(
				 [dim_employee_incident_classification_key]
				,[dim_employee_incident_id_key]
				,[incident_id] 
				,[incident_classification_level1_code] 
				,[incident_classification_level1_name] 
				,[incident_classification_level2_code] 
				,[incident_classification_level2_name] 
				,[incident_classification_level3_code] 
				,[incident_classification_level3_name] 
				,[incident_classification_notes] 
				,[DWHBatchId] 
				,[DWHCreatedAt] 
				,[DWHModifiedOn] 
				,[DWHDMLOperation] 
				,[DWHSourceSystem]   
			)
			VALUES	(0,0,0,'N/A','N/A','N/A','N/A','N/A','N/A','N/A',0,@systemCurrentDate,@systemCurrentDate,'I',@SourceSystem),	
			(-1,-1,-1,'Unknown','Unknown','Unknown','Unknown','Unknown','Unknown','Unknown',0,@systemCurrentDate,@systemCurrentDate,'I',@SourceSystem)
			 -- turn the identity insert off
			SET IDENTITY_INSERT [edw].[dim_employee_incident_classification] OFF
	end
	
		if( not exists (select top(1) 1 from [edw].[dim_employee_incident_classification] where dim_employee_incident_classification_key > 0 ) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[dim_employee_incident_classification]
			(
				 [dim_employee_incident_id_key]
				,[incident_id] 
				,[incident_classification_level1_code] 
				,[incident_classification_level1_name] 
				,[incident_classification_level2_code] 
				,[incident_classification_level2_name] 
				,[incident_classification_level3_code] 
				,[incident_classification_level3_name] 
				,[incident_classification_notes] 
				,[DWHBatchId] 
				,[DWHCreatedAt] 
				,[DWHModifiedOn] 
				,[DWHDMLOperation] 
				,[DWHSourceSystem] 
			)
			select
				 src.[dim_employee_incident_id_key]
				,src.[incident_id] 
				,src.[incident_classification_level1_code] 
				,src.[incident_classification_level1_name] 
				,src.[incident_classification_level2_code] 
				,src.[incident_classification_level2_name] 
				,src.[incident_classification_level3_code] 
				,src.[incident_classification_level3_name] 
				,src.[incident_classification_notes] 
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLdim_employee_incident_classification] as src;
		end else begin
			merge into [edw].[dim_employee_incident_classification] as trg
			using 
			(
				select
				 src.[dim_employee_incident_id_key]
				,src.[incident_id] 
				,src.[incident_classification_level1_code] 
				,src.[incident_classification_level1_name] 
				,src.[incident_classification_level2_code] 
				,src.[incident_classification_level2_name] 
				,src.[incident_classification_level3_code] 
				,src.[incident_classification_level3_name] 
				,src.[incident_classification_notes] 
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLdim_employee_incident_classification] as src
			) as src on (src.[incident_id] = trg.[incident_id] collate database_default and src.[incident_classification_level1_code] IS NOT DISTINCT FROM trg.[incident_classification_level1_code] collate database_default and src.[incident_classification_level2_code] IS NOT DISTINCT FROM trg.[incident_classification_level2_code] collate database_default and src.[incident_classification_level3_code] IS NOT DISTINCT FROM trg.[incident_classification_level3_code] collate database_default)			-- Retire existing records
			when matched and exists 
			( 
				select src.[dim_employee_incident_id_key], src.[incident_classification_level1_name], src.[incident_classification_level2_name], src.[incident_classification_level3_name], src.[incident_classification_notes]
				except
				select trg.[dim_employee_incident_id_key], trg.[incident_classification_level1_name], trg.[incident_classification_level2_name], trg.[incident_classification_level3_name], trg.[incident_classification_notes]
			) then  update set 
				  [dim_employee_incident_id_key] = src.[dim_employee_incident_id_key]
				, [incident_id] = src.[incident_id]
				, [incident_classification_level1_code] = src.[incident_classification_level1_code]
				, [incident_classification_level1_name] = src.[incident_classification_level1_name]
				, [incident_classification_level2_code] = src.[incident_classification_level2_code]
				, [incident_classification_level2_name] = src.[incident_classification_level2_name]
				, [incident_classification_level3_code] = src.[incident_classification_level3_code]
				, [incident_classification_level3_name] = src.[incident_classification_level3_name]
				, [incident_classification_notes] = src.[incident_classification_notes]
				,[DWHModifiedOn] = @systemCurrentDate
				,[DWHBatchId] = @BatchID
				,[DWHDMLOperation] = isnull(nullif(src.[DWHDMLOperation],'I'),'U')
			-- Soft delete missing records
			when not matched by source and trg.[DWHDMLOperation] <> 'D' and trg.dim_employee_incident_classification_key > 0 then update set [DWHModifiedOn] = @systemCurrentDate, [DWHDMLOperation] = 'D'
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [dim_employee_incident_id_key]
					,[incident_id] 
					,[incident_classification_level1_code] 
					,[incident_classification_level1_name] 
					,[incident_classification_level2_code] 
					,[incident_classification_level2_name] 
					,[incident_classification_level3_code] 
					,[incident_classification_level3_name] 
					,[incident_classification_notes] 
					,[DWHBatchId] 
					,[DWHCreatedAt] 
					,[DWHModifiedOn] 
					,[DWHDMLOperation] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[dim_employee_incident_id_key]
					,src.[incident_id] 
					,src.[incident_classification_level1_code] 
					,src.[incident_classification_level1_name] 
					,src.[incident_classification_level2_code] 
					,src.[incident_classification_level2_name] 
					,src.[incident_classification_level3_code] 
					,src.[incident_classification_level3_name] 
					,src.[incident_classification_notes] 
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
		from [edw].[dim_employee_incident_classification];

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