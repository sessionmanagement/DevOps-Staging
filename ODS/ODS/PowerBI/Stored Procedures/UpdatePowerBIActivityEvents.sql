create procedure [PowerBI].[UpdatePowerBIActivityEvents] 
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
	declare @SourceSystem nvarchar(120) = '[PowerBI].[ActivityEvents]';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	-- Check if there are records in the source table
	select @stagedRecords = count(1) from [Staging].[PowerBI_ActivityEvents];

	-- Full load - insert all from landing
	begin try

		create external table [PowerBI].[ActivityEvents]
			with (
				location = 'PowerBI/ActivityEvents/main' ,
				data_source = [data],
				file_format = [parquet]
			) as 		
		select  src.[Activity] ,src.[ActivityEventId] ,src.[ActivityId] ,src.[AggregatedWorkspaceCount] ,src.[AggregatedWorkspacesByCapacitySku] ,src.[AggregatedWorkspacesByType] ,src.[AppName] ,src.[AppReportId] ,src.[ArtifactId] ,src.[ArtifactName] ,src.[CapacityId] ,src.[CapacityName] ,src.[ClientIP] ,src.[ConsumptionMethod] ,src.[CreationTime] ,src.[DashboardId] ,src.[DashboardName] ,src.[DataConnectivityMode] ,src.[DataflowAccessTokenEntityName] ,src.[DataflowAccessTokenLifetimeInMinutes] ,src.[DataflowAccessTokenPartitionUri] ,src.[DataflowAccessTokenPermissions] ,src.[DataflowId] ,src.[DataflowName] ,src.[DataflowType] ,src.[DatasetCertificationStage] ,src.[DatasetId] ,src.[DatasetName] ,src.[Datasets] ,src.[DatasourceObjectIds] ,src.[DistributionMethod] ,src.[EmbedTokenId] ,src.[ExportEventEndDateTimeParameter] ,src.[ExportEventStartDateTimeParameter] ,src.[ExportedArtifactArtifactId] ,src.[ExportedArtifactArtifactType] ,src.[ExportedArtifactExportType] ,src.[ExternalSubscribeeInformation] ,src.[FolderAccessRequests] ,src.[FolderAccessRequestsUserId] ,src.[FolderAccessRequestsRolePermissions] ,src.[FolderAccessRequestsUserObjectId] ,src.[FolderAccessRequestsGroupObjectId] ,src.[FolderDisplayName] ,src.[FolderObjectId] ,src.[GatewayId] ,src.[GenerateScreenshotEngineType] ,src.[GenerateScreenshotExportFormat] ,src.[GenerateScreenshotExportSourceType] ,src.[GenerateScreenshotExportType] ,src.[GenerateScreenshotExportUrl] ,src.[ImportDisplayName] ,src.[ImportId] ,src.[ImportSource] ,src.[ImportType] ,src.[IsSuccess] ,src.[ItemName] ,src.[LastRefreshTime] ,src.[ModelId] ,src.[ModelsSnapshots] ,src.[Monikers] ,src.[ObjectId] ,src.[Operation] ,src.[OrgAppPermission] ,src.[OrgAppPermissionRecipients] ,src.[OrganizationId] ,src.[RLSIdentitiesDatasets] ,src.[RLSIdentitiesRoles] ,src.[RLSIdentitiesUsername] ,src.[RecordType] ,src.[RefreshType] ,src.[ReportId] ,src.[ReportName] ,src.[ReportType] ,src.[RequestId] ,src.[SharingAction] ,src.[SharingInformation] ,src.[SubscribeeInformation] ,src.[SubscriptionSchedule] ,src.[SubscriptionScheduleEndDate] ,src.[SubscriptionScheduleStartDate] ,src.[SubscriptionScheduleTime] ,src.[SubscriptionScheduleTimeZone] ,src.[SubscriptionScheduleType] ,src.[SubscriptionScheduleWeekDays] ,src.[SwitchState] ,src.[UserAgent] ,src.[UserId] ,src.[UserKey] ,src.[UserType] ,src.[WorkSpaceName] ,src.[Workload] ,src.[WorkspaceId] ,src.[EventYear] ,src.[EventMonth] ,src.[EventDate] ,src.[ADF_PipelineRunId] ,src.[ADF_PipelineTriggerTime] , @systemCurrentDate as [ODSCreatedAt], @batchID as [ODSBatchId], @SourceSystem as [ODSSourceSystem]
			from [Staging].[PowerBI_ActivityEvents] src
		
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