create procedure [kpi].[Updatekpitarget_definitions] 
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
	declare @SourceSystem nvarchar(120) = '[kpi].[target_definitions]';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	-- Check if there are records in the source table
	select @stagedRecords = count(1) from [Staging].[kpi_target_definitions];

	-- Full load - insert all from landing
	begin try

		create external table [kpi].[target_definitions]
			with (
				location = 'kpi/target_definitions/main' ,
				data_source = [data],
				file_format = [parquet]
			) as 		
		select  src.[id] ,src.[service_id] ,src.[service_code] ,src.[service_name] ,src.[case_load] ,src.[fully_staffed_fte] ,src.[support_hours] ,src.[region] ,src.[temp_region] ,src.[district] ,src.[service_type_lookup_id] ,src.[fully_staffed_applies] ,src.[prog_delievered_target_applies] ,src.[programmes_delivered] ,src.[bed_nights] ,src.[bed_nights_applied] ,src.[support_hours_applied] ,src.[case_load_targets_appliced] ,src.[service_action_plan_link] ,src.[outcome_tool_review] ,src.[goal_planning_applied] , @systemCurrentDate as [ODSCreatedAt], @batchID as [ODSBatchId], @SourceSystem as [ODSSourceSystem]
			from [Staging].[kpi_target_definitions] src
		
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