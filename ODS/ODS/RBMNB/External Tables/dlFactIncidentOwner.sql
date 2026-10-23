CREATE EXTERNAL TABLE [RBMNB].[dlFactIncidentOwner] (
    [IncidentOwnerID] INT NULL,
    [IncidentOwnerOwnerType] CHAR (1) NULL,
    [UserID] INT NULL,
    [IncidentOwnerRawComments] NVARCHAR (MAX) NULL,
    [IncidentOwnerHtmlComments] NVARCHAR (MAX) NULL,
    [IncidentID] INT NULL,
    [IncidentOwnerCreatedDate] DATETIME NULL,
    [IncidentOwnerCreatedUserID] INT NULL,
    [IncidentOwnerOwnerName] NVARCHAR (100) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactIncidentOwner/main',
    FILE_FORMAT = [parquet]
    );

