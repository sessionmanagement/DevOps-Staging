CREATE EXTERNAL TABLE [landing].[RBMNB_dlFactIncidentOwner] (
    [IncidentOwnerID] INT NULL,
    [IncidentOwnerOwnerType] CHAR (1) NULL,
    [UserID] INT NULL,
    [IncidentOwnerRawComments] NVARCHAR (MAX) NULL,
    [IncidentOwnerHtmlComments] NVARCHAR (MAX) NULL,
    [IncidentID] INT NULL,
    [IncidentOwnerCreatedDate] DATETIME NULL,
    [IncidentOwnerCreatedUserID] INT NULL,
    [IncidentOwnerOwnerName] NVARCHAR (100) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactIncidentOwner/landing',
    FILE_FORMAT = [parquet]
    );

