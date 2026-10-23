CREATE EXTERNAL TABLE [working].[RBEAL_dlFactIncidentCategory] (
    [IncidentCategoryID] INT NULL,
    [IncidentID] INT NULL,
    [IncidentCategoryTypeID] INT NULL,
    [IncidentCategoryCreatedUserID] INT NULL,
    [IncidentCategoryCreatedDate] DATETIME NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactIncidentCategory/working',
    FILE_FORMAT = [parquet]
    );

