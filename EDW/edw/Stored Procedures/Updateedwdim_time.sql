





/**********************************************************************************************************
 Procedure	[edw].[Updateedwdim_time]
 Author		
 Created		
 Purpose		
				

				
 Notes: Call By	EDW Pipeline '30_Load_From_ODS'
	
 =========================================================================================================

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2024-04-15	  Manish Singh			Initial version
2.0     2024-05-21	  Manish Singh			Changed time column to null to handle default record


**********************************************************************************************************/

CREATE procedure [edw].[Updateedwdim_time] 
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
	declare @SourceSystem nvarchar(120) = '[ETL].[dim_time]';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	-- Do not run if there are records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLdim_time];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[dim_time];

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
					FROM [edw].[dim_time]
					WHERE dim_time_key <= 0
					)
				)
		BEGIN
			-- turn the identity insert on 
			--SET IDENTITY_INSERT [edw].[dim_time] ON

			INSERT INTO [edw].[dim_time]   
			([dim_time_key]
           ,[time]
           ,[hour_12h]
           ,[hour_24h]
           ,[minute]
           ,[second]
           ,[am.pm]
           ,[standard_time]
           ,[DWHBatchId]
           ,[DWHCreatedAt]
           ,[DWHModifiedOn]
           ,[DWHDMLOperation]
           ,[DWHSourceSystem])
			VALUES 
				(
				-1
				,null
				,'unk'
				,'unk'
				,'unk'
				,'unk'
				,'unk'
				,'unknown'
				,@BatchID 
				,getdate() 
				,getdate() 
				,'I' 
				,@SourceSystem 
				)

			-- turn the identity insert off
			--SET IDENTITY_INSERT [edw].[dim_time] OFF
		END


		if( not exists (select top(1) 1 from [edw].[dim_time]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[dim_time]
			(
            [dim_time_key]
           ,[time]
           ,[hour_12h]
           ,[hour_24h]
           ,[minute]
           ,[second]
           ,[am.pm]
           ,[standard_time]
           ,[DWHBatchId]
           ,[DWHCreatedAt]
           ,[DWHModifiedOn]
           ,[DWHDMLOperation]
           ,[DWHSourceSystem]
			)
			select
            src.[timekey]
           ,src.[time]
           ,src.[hour_12h]
           ,src.[hour_24h]
           ,src.[minute]
           ,src.[second]
           ,src.[am.pm]
           ,src.[standard_time] 
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLdim_time] as src;
		end else begin
			merge into [edw].[dim_time] as trg
			using 
			(
				select
            src.[timekey]
           ,src.[time]
           ,src.[hour_12h]
           ,src.[hour_24h]
           ,src.[minute]
           ,src.[second]
           ,src.[am.pm]
           ,src.[standard_time]
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLdim_time] as src
			) as src on (src.[timekey] = trg.[dim_time_key])			-- Retire existing records
			when matched and exists 
			( 
				select src.timekey,src.[time] ,src.[hour_12h],src.[hour_24h],src.[minute],src.[second],src.[am.pm] ,src.[standard_time]
				except
				select trg.[dim_time_key],trg.[time] ,trg.[hour_12h],trg.[hour_24h],trg.[minute],trg.[second],trg.[am.pm] ,trg.[standard_time]
			) then  update set 
				 [dim_time_key] = src.timekey
				, [time] = src.[time]
				, [hour_12h] = src.[hour_12h]
				, [hour_24h] = src.[hour_24h]
				, [minute] = src.[minute]
				, [second] = src.[second]
				, [am.pm]=src.[am.pm]
				,[standard_time]=src.[standard_time]
				,[DWHModifiedOn] = @systemCurrentDate
				,[DWHBatchId] = @BatchID
				,[DWHDMLOperation] = isnull(nullif(src.[DWHDMLOperation],'I'),'U')
			-- Soft delete missing records
			when not matched by source 
				and trg.[dim_time_key] > 0
				and trg.[DWHDMLOperation] <> 'D' 
			then update set [DWHModifiedOn] = @systemCurrentDate, [DWHDMLOperation] = 'D'
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [dim_time_key]
					,[time]
					,[hour_12h]
					,[hour_24h]
					,[minute]
					,[second]
					,[am.pm]
					,[standard_time]
					,[DWHBatchId] 
					,[DWHCreatedAt] 
					,[DWHModifiedOn] 
					,[DWHDMLOperation] 
					,[DWHSourceSystem] 
				)
				values
				(
                 src.[timekey]
                ,src.[time]
                ,src.[hour_12h]
                ,src.[hour_24h]
                ,src.[minute]
                ,src.[second]
                ,src.[am.pm]
                ,src.[standard_time]
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
		from [edw].[dim_time];

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