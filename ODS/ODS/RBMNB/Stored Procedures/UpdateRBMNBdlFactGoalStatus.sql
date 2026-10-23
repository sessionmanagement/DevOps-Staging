create procedure [RBMNB].[UpdateRBMNBdlFactGoalStatus] 
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
	declare @SourceSystem nvarchar(120) = '[dl].[FactGoalStatus]';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	-- Check if there are records in the source table
	select @stagedRecords = count(1) from [Staging].[RBMNB_dlFactGoalStatus];

	-- Full load - insert all from landing
	begin try

		create external table [RBMNB].[dlFactGoalStatus]
			with (
				location = 'RBMNB/dlFactGoalStatus/main' ,
				data_source = [data],
				file_format = [parquet]
			) as 		
		select  src.[GoalStatusID] ,src.[GoalID] ,src.[GoalStatusPercentageComplete] ,src.[GoalStatusComments] ,src.[GoalStatusCreatedUserID] ,src.[GoalStatusCreatedDate] ,src.[GoalStatusProgressDate] , @systemCurrentDate as [ODSCreatedAt], @batchID as [ODSBatchId], @SourceSystem as [ODSSourceSystem]
			from [Staging].[RBMNB_dlFactGoalStatus] src
		
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