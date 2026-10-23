CREATE EXTERNAL TABLE [staging].[RBMNB_dlDimIncidentSeverity] (
    [IncidentSeverityID] INT NULL,
    [IncidentSeverityValue] NVARCHAR (200) NULL,
    [IncidentSeverityText] NVARCHAR (200) NULL,
    [IncidentSeverityParentId] INT NULL,
    [IncidentSeverityIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimIncidentSeverity/staging',
    FILE_FORMAT = [parquet]
    );

