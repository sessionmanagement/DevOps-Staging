CREATE EXTERNAL TABLE [landing].[RBEAL_dlFactIncidentStatus] (
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
    LOCATION = N'RBEAL/dlFactIncidentStatus/landing',
    FILE_FORMAT = [parquet]
    );

