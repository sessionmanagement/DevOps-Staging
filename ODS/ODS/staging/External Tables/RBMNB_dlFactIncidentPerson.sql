CREATE EXTERNAL TABLE [staging].[RBMNB_dlFactIncidentPerson] (
    [IncidentPersonID] INT NULL,
    [IncidentID] INT NULL,
    [IncidentPersonEntityType] NVARCHAR (50) NULL,
    [EntityID] INT NULL,
    [IncidentPersonRole] NVARCHAR (150) NULL,
    [IncidentPersonIsComplainant] INT NULL,
    [IncidentPersonRawComments] NVARCHAR (MAX) NULL,
    [IncidentPersonHtmlComments] NVARCHAR (MAX) NULL,
    [IncidentPersonCreatedUserID] INT NULL,
    [IncidentPersonCreatedDate] DATETIME NULL,
    [RoleId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactIncidentPerson/staging',
    FILE_FORMAT = [parquet]
    );

