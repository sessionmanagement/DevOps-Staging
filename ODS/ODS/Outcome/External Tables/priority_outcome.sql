CREATE EXTERNAL TABLE [Outcome].[priority_outcome] (
    [priority_outcome_id] INT NULL,
    [priority_outcome] NVARCHAR (255) NULL,
    [wellbeing_domain_id] NVARCHAR (255) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Outcome/priority_outcome/main',
    FILE_FORMAT = [parquet]
    );

