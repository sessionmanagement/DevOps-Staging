CREATE EXTERNAL TABLE [staging].[RBEAL_dlDimIncidentSeverity] (
    [IncidentSeverityID] INT NULL,
    [IncidentSeverityValue] NVARCHAR (200) NULL,
    [IncidentSeverityText] NVARCHAR (200) NULL,
    [IncidentSeverityParentId] INT NULL,
    [IncidentSeverityIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimIncidentSeverity/staging',
    FILE_FORMAT = [parquet]
    );

