CREATE EXTERNAL TABLE [Outcome].[specific_outcome] (
    [specific_outcome_id] INT NULL,
    [specific_outcome] NVARCHAR (255) NULL,
    [priority_outcome_id] NVARCHAR (255) NULL,
    [wellbeing_domain_id] NVARCHAR (255) NULL,
    [relates_to] NVARCHAR (255) NULL,
    [relates_to_2] NVARCHAR (255) NULL,
    [relates_to_3] NVARCHAR (255) NULL,
    [relates_to_4] NVARCHAR (255) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Outcome/specific_outcome/main',
    FILE_FORMAT = [parquet]
    );

