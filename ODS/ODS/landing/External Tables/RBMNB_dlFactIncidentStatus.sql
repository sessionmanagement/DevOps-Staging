CREATE EXTERNAL TABLE [landing].[RBMNB_dlFactIncidentStatus] (
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
    LOCATION = N'RBMNB/dlFactIncidentStatus/landing',
    FILE_FORMAT = [parquet]
    );

