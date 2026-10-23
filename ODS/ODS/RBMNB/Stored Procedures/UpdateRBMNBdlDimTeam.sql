create procedure [RBMNB].[UpdateRBMNBdlDimTeam] 
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
	declare @SourceSystem nvarchar(120) = '[dl].[DimTeam]';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	-- Check if there are records in the source table
	select @stagedRecords = count(1) from [Staging].[RBMNB_dlDimTeam];

	-- Full load - insert all from landing
	begin try

		create external table [RBMNB].[dlDimTeam]
			with (
				location = 'RBMNB/dlDimTeam/main' ,
				data_source = [data],
				file_format = [parquet]
			) as 		
		select  src.[TeamID] ,src.[TeamCode] ,src.[TeamName] ,src.[TeamDescription] ,src.[CompanyID] ,src.[ContractID] ,src.[TeamFunctionID] ,src.[TeamAutoAccept] ,src.[TeamCapacity] ,src.[AreaID] ,src.[TeamStartDate] ,src.[TeamEndDate] ,src.[OldTeamID] ,src.[OldSupportLevelID] ,src.[TeamUDF1] ,src.[TeamUDF2] ,src.[TeamUDF3] ,src.[TeamUDF4] ,src.[TeamUDF5] ,src.[TeamUDF6] ,src.[TeamUDF7] ,src.[TeamUDF8] ,src.[TeamUDF9] ,src.[TeamUDF10] ,src.[TeamLUDF1] ,src.[TeamLUDF2] ,src.[TeamLUDF3] ,src.[TeamLUDF4] ,src.[TeamLUDF5] ,src.[TeamRecentlyDischargedPeriodDaysOverride] ,src.[SupportLevelTypeID] ,src.[TaskProcessID] ,src.[TeamIsEmploymentTeam] ,src.[EmploymentPlanTemplateID] ,src.[TeamIsAllocatedSupportTimeTeam] ,src.[TeamReferenceNumberRequired] ,src.[TeamIsFosterCarerTeam] ,src.[TeamIsFosterChildTeam] ,src.[DynamicFormID] ,src.[TeamShowGlobalActivityTemplate] , @systemCurrentDate as [ODSCreatedAt], @batchID as [ODSBatchId], @SourceSystem as [ODSSourceSystem]
			from [Staging].[RBMNB_dlDimTeam] src
		
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