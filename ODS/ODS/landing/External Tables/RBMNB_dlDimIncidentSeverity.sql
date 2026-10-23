CREATE EXTERNAL TABLE [landing].[RBMNB_dlDimIncidentSeverity] (
    [IncidentSeverityID] INT NULL,
    [IncidentSeverityValue] NVARCHAR (200) NULL,
    [IncidentSeverityText] NVARCHAR (200) NULL,
    [IncidentSeverityParentId] INT NULL,
    [IncidentSeverityIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimIncidentSeverity/landing',
    FILE_FORMAT = [parquet]
    );

