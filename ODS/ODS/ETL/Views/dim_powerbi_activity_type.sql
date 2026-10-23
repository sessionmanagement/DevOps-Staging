


--SELECT -1, N'Unknown', N'', N'', N''   UNION

--SELECT * FROM ETL.dim_powerbi_activity_type
--DROP VIEW ETL.dim_powerbi_activity_type

CREATE VIEW [ETL].[dim_powerbi_activity_type] AS 
( --select -1 dim_powerbi_activity_type, 'Unknown' as activity, '' as activity_group , '' as activity_description, '' as activity_notes
select      'AddDatasourceToGateway' as activity,'Gateway'  as activity_group,'Added data source to Power BI gateway' as activity_description,'' as activity_notes   Union
select      'AddFolderAccess','Admin / Security','Added Power BI folder access',''   Union
select      'AddGroupMembers','Admin / Security','Added Power BI group members',''   Union
select      'AdminAttachedDataflowStorageAccountToTenant','Admin / Security','Admin attached dataflow storage account to tenant',''   Union
select      'AnalyzedByExternalApplication','View (Report / Dashboard / App   UNION','Analyzed Power BI dataset',''   Union
select      'AnalyzeInExcel','View (Report / Dashboard / App   UNION','Analyzed Power BI report',''   Union
select      'AttachedDataflowStorageAccount','Dataflow','Attached dataflow storage account',''   Union
select      'BindToGateway','Gateway','Binded Power BI dataset to gateway',''   Union
select      'CancelDataflowRefresh','Dataflow','Canceled dataflow refresh',''   Union
select      'ChangeCapacityState','Capacity','Changed capacity state',''   Union
select      'UpdateCapacityUsersAssignment','Capacity','Changed capacity user assignment',''   Union
select      'SetAllConnections','Dataset','Changed Power BI dataset connections',''   Union
select      'ChangeGatewayAdministrators','Gateway','Changed Power BI gateway admins',''   Union
select      'ChangeGatewayDatasourceUsers','Gateway','Changed Power BI gateway data source users',''   Union
select      'CreateOrgApp','Admin / Security','Created organizational Power BI content pack',''   Union
select      'CreateApp','Create (Report / Dashboard / App   UNION','Created Power BI app',''   Union
select      'CreateDashboard','Create (Report / Dashboard / App   UNION','Created Power BI dashboard',''   Union
select      'CreateDataflow','Dataflow','Created Power BI dataflow',''   Union
select      'CreateDataset','Dataset','Created Power BI dataset',''   Union
select      'CreateEmailSubscription','Subscription','Created Power BI email subscription',''   Union
select      'CreateFolder','Admin / Security','Created Power BI folder',''   Union
select      'CreateGateway','Gateway','Created Power BI gateway',''   Union
select      'CreateGroup','Admin / Security','Created Power BI group',''   Union
select      'CreateReport','Create (Report / Dashboard / App   UNION','Created Power BI report',''   Union
select      'DataflowMigratedToExternalStorageAccount','Dataflow','Dataflow migrated to external storage account',''   Union
select      'DataflowPermissionsAdded','Dataflow','Dataflow permissions added',''   Union
select      'DataflowPermissionsRemoved','Dataflow','Dataflow permissions removed',''   Union
select      'DeleteOrgApp','Admin / Security','Deleted organizational Power BI content pack',''   Union
select      'DeleteComment','Delete (Report / Dashboard / App   UNION','Deleted Power BI comment',''   Union
select      'DeleteDashboard','Delete (Report / Dashboard / App   UNION','Deleted Power BI dashboard',''   Union
select      'DeleteDataflow','Dataflow','Deleted Power BI dataflow',''   Union
select      'DeleteDataset','Dataset','Deleted Power BI dataset',''   Union
select      'DeleteEmailSubscription','Subscription','Deleted Power BI email subscription',''   Union
select      'DeleteFolder','Admin / Security','Deleted Power BI folder',''   Union
select      'DeleteFolderAccess','Admin / Security','Deleted Power BI folder access',''   Union
select      'DeleteGateway','Gateway','Deleted Power BI gateway',''   Union
select      'DeleteGroup','Admin / Security','Deleted Power BI group',''   Union
select      'DeleteReport','Delete (Report / Dashboard / App   UNION','Deleted Power BI report',''   Union
select      'GetDatasources','Dataset','Discovered Power BI dataset data sources',''   Union
select      'DownloadReport','Export / Print / Download','Downloaded Power BI report',''   Union
select      'EditDataflowProperties','Dataflow','Edited dataflow properties',''   Union
select      'EditCertificationPermission','Admin / Security','Edited Power BI certification permission',''   Union
select      'EditDashboard','Edit / Update (Report / Dashboard / App   UNION','Edited Power BI dashboard',''   Union
select      'EditDataset','Dataset','Edited Power BI dataset',''   Union
select      'EditDatasetProperties','Dataset','Edited Power BI dataset properties',''   Union
select      'EditReport','Edit / Update (Report / Dashboard / App   UNION','Edited Power BI report',''   Union
select      'ExportDataflow','Dataflow','Exported Power BI dataflow',''   Union
select      'ExportReport','Export / Print / Download','Exported Power BI report visual data',''   Union
select      'ExportTile','Export / Print / Download','Exported Power BI tile data',''   Union
select      'FailedToAddDataflowPermissions','Dataflow','Failed to add dataflow permissions',''   Union
select      'FailedToRemoveDataflowPermissions','Dataflow','Failed to remove dataflow permissions',''   Union
select      'GenerateDataflowSasToken','Dataflow','Generated Power BI dataflow SAS token',''   Union
select      'GenerateEmbedToken','Admin / Security','Generated Power BI Embed Token',''   Union
select      'Import','Import','Imported file to Power BI',''   Union
select      'InstallApp','Licensing / Account','Installed Power BI app',''   Union
select      'MigrateWorkspaceIntoCapacity','Capacity','Migrated workspace to a capacity',''   Union
select      'PostComment','Edit / Update (Report / Dashboard / App   UNION','Posted Power BI comment',''   Union
select      'PrintDashboard','Export / Print / Download','Printed Power BI dashboard',''   Union
select      'PrintReport','Export / Print / Download','Printed Power BI report page',''   Union
select      'PublishToWebReport','Export / Print / Download','Published Power BI report to web',''   Union
select      'ReceiveDataflowSecretFromKeyVault','Dataflow','Received Power BI dataflow secret from Key Vault',''   Union
select      'RemoveDatasourceFromGateway','Gateway','Removed data source from Power BI gateway',''   Union
select      'DeleteGroupMembers','Admin / Security','Removed Power BI group members',''   Union
select      'RemoveWorkspacesFromCapacity','Capacity','Removed workspace from a capacity',''   Union
select      'RenameDashboard','Edit / Update (Report / Dashboard / App   UNION','Renamed Power BI dashboard',''   Union
select      'RequestDataflowRefresh','Dataflow','Requested Power BI dataflow refresh',''   Union
select      'RefreshDataset','Dataset','Requested Power BI dataset refresh',''   Union
select      'GetWorkspaces','View (Report / Dashboard / App   UNION','Retrieved Power BI workspaces',''   Union
select      'SetDataflowStorageLocationForWorkspace','Dataflow','Set dataflow storage location for a workspace',''   Union
select      'SetScheduledRefreshOnDataflow','Dataflow','Set scheduled refresh on Power BI dataflow',''   Union
select      'SetScheduledRefresh','Dataset','Set scheduled refresh on Power BI dataset',''   Union
select      'ShareDashboard','Sharing','Shared Power BI dashboard',''   Union
select      'ShareReport','Sharing','Shared Power BI report',''   Union
select      'OptInForExtendedProTrial','Licensing / Account','Started Power BI extended trial',''   Union
--select      'OptInForExtendedProTrial','Licensing / Account','Started Power BI extended trial','N'   Union
select      'OptInForProTrial','Licensing / Account','Started Power BI trial',''   Union
select      'TakeOverDatasource','Admin / Security','Took over a Power BI datasource',''   Union
select      'TakeOverDataset','Admin / Security','Took over Power BI dataset',''   Union
select      'TookOverDataflow','Admin / Security','Took over a Power BI dataflow',''   Union
select      'UnpublishApp','Delete (Report / Dashboard / App   UNION','Unpublished Power BI app',''   Union
select      'UpdateCapacityResourceGovernanceSettings','Capacity','Update capacity resource governance settings',''   Union
select      'UpdateCapacityAdmins','Capacity','Updated capacity admin',''   Union
select      'UpdateCapacityDisplayName','Capacity','Updated capacity display name',''   Union
select      'UpdatedDataflowStorageAssignmentPermissions','Dataflow','Updated dataflow storage assignment permissions',''   Union
select      'UpdatedAdminFeatureSwitch','Admin / Security','Updated organizations Power BI settings',''   Union
select      'UpdateApp','Edit / Update (Report/Dashboard/ App  UNION','Updated Power BI app',''   Union
select      'UpdateDataflow','Dataflow','Updated Power BI dataflow',''   Union
select      'UpdateDatasources','Dataset','Updated Power BI dataset data sources',''   Union
select      'UpdateDatasetParameters','Dataset','Updated Power BI dataset parameters',''   Union
select      'UpdateEmailSubscription','Subscription','Updated Power BI email subscription',''   Union
select      'UpdateFolder','Admin / Security','Updated Power BI folder',''   Union
select      'UpdateFolderAccess','Admin / Security','Updated Power BI folder access',''   Union
select      'UpdateDatasourceCredentials','Gateway','Updated Power BI gateway data source credentials',''   Union
select      'ViewDashboard','View (Report / Dashboard / App   UNION','Viewed Power BI dashboard',''   Union
select      'ViewDataflow','Dataflow','Viewed Power BI dataflow',''   Union
select      'ViewReport','View (Report / Dashboard / App   UNION','Viewed Power BI report',''   Union
select      'ViewTile','View (Report / Dashboard / App   UNION','Viewed Power BI tile',''   Union
select      'ViewUsageMetrics','Admin / Security','Viewed Power BI usage metrics',''   Union
select      'ExportArtifact','Export / Print / Download','Export a Power BI Item','' 
)