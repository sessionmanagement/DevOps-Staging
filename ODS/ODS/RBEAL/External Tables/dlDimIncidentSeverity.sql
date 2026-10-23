CREATE EXTERNAL TABLE [RBEAL].[dlDimIncidentSeverity] (
    [IncidentSeverityID] INT NULL,
    [IncidentSeverityValue] NVARCHAR (200) NULL,
    [IncidentSeverityText] NVARCHAR (200) NULL,
    [IncidentSeverityParentId] INT NULL,
    [IncidentSeverityIsActive] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimIncidentSeverity/main',
    FILE_FORMAT = [parquet]
    );

