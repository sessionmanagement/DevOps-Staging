CREATE EXTERNAL TABLE [staging].[RBEAL_dlFactIncidentStatus] (
    [IncidentStatusID] INT NULL,
    [IncidentID] INT NULL,
    [IncidentStatusTypeID] INT NULL,
    [IncidentStatusCreatedUserID] INT NULL,
    [IncidentStatusCreatedDate] DATETIME NULL,
    [IncidentStatusRawComment] NVARCHAR (MAX) NULL,
    [IncidentStatusHtmlComment] NVARCHAR (MAX) NULL,
    [IncidentStatusEndDate] DATETIME NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactIncidentStatus/staging',
    FILE_FORMAT = [parquet]
    );

