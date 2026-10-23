create procedure [sixdegrees].[Updatesixdegreesentity] 
	@pBatchID int,
	@pMode varchar(10) = 'Full'
as begin
	set nocount on;
	set xact_abort on;

	declare @pErrorRecords		int;
	declare @pInsertRecords		int;
	declare @pUpdateRecords		int;
	declare @pDeleteRecords		int;
	declare @pCompleted			int;
	declare @pTargetRecords		int;

	-- Variables
	declare @batchID int = @pBatchID;
	declare @SourceSystem nvarchar(120) = '[sixdegrees].[entity]';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	-- Check if there are records in the source table
	select @stagedRecords = count(1) from [Staging].[sixdegrees_entity];

	-- Full load - insert all from landing
	begin try

		create external table [sixdegrees].[entity]
			with (
				location = 'sixdegrees/entity/main' ,
				data_source = [data],
				file_format = [parquet]
			) as 		
		select  src.[entity_hierarchy_order_no] ,src.[entity_hierarchy_key] ,src.[entity_hierarchy_code] ,src.[entity_hierarchy_description] ,src.[entity_hierarchy_level_no] ,src.[entity_hierarchy_parent_key] ,src.[entity_hierarchy_ancestor_keys] ,src.[entity_hierarchy_L00_key] ,src.[entity_hierarchy_L01_key] ,src.[entity_hierarchy_L02_key] ,src.[entity_hierarchy_L03_key] ,src.[entity_hierarchy_L04_key] ,src.[entity_hierarchy_L05_key] ,src.[entity_hierarchy_L06_key] ,src.[entity_hierarchy_L07_key] ,src.[entity_hierarchy_L08_key] ,src.[entity_hierarchy_L09_key] ,src.[entity_hierarchy_L10_key] ,src.[entity_hierarchy_L11_key] ,src.[entity_hierarchy_L12_key] ,src.[entity_hierarchy_L13_key] ,src.[entity_hierarchy_L14_key] ,src.[entity_hierarchy_L15_key] ,src.[entity_hierarchy_L16_key] , @systemCurrentDate as [ODSCreatedAt], @batchID as [ODSBatchId], @SourceSystem as [ODSSourceSystem]
			from [Staging].[sixdegrees_entity] src
		
		-- Select return parameters as a dataset
		select	0				as ErrorRecords,
				@stagedRecords	as InsertRecords,
				0				as UpdateRecords,
				0				as DeleteRecords,
				1				as Completed,
				@stagedRecords	as TargetRecords;

		return;

	end try
	begin catch
		-- Select return parameters as a dataset
		select	0				as ErrorRecords,
				0				as InsertRecords,
				0				as UpdateRecords,
				0				as DeleteRecords,
				0				as Completed,
				0				as TargetRecords;
		throw;
	end catch

end;