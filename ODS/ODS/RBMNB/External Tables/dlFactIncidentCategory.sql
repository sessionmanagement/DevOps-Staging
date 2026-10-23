CREATE EXTERNAL TABLE [RBMNB].[dlFactIncidentCategory] (
    [IncidentCategoryID] INT NULL,
    [IncidentID] INT NULL,
    [IncidentCategoryTypeID] INT NULL,
    [IncidentCategoryCreatedUserID] INT NULL,
    [IncidentCategoryCreatedDate] DATETIME NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactIncidentCategory/main',
    FILE_FORMAT = [parquet]
    );

