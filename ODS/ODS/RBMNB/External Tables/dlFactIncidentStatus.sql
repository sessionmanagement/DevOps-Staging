CREATE EXTERNAL TABLE [RBMNB].[dlFactIncidentStatus] (
    [IncidentStatusID] INT NULL,
    [IncidentID] INT NULL,
    [IncidentStatusTypeID] INT NULL,
    [IncidentStatusCreatedUserID] INT NULL,
    [IncidentStatusCreatedDate] DATETIME NULL,
    [IncidentStatusRawComment] NVARCHAR (MAX) NULL,
    [IncidentStatusHtmlComment] NVARCHAR (MAX) NULL,
    [IncidentStatusEndDate] DATETIME NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactIncidentStatus/main',
    FILE_FORMAT = [parquet]
    );

