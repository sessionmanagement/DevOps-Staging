CREATE EXTERNAL TABLE [Outcome].[wellbeing_domain] (
    [wellbeing_domain_id] INT NULL,
    [wellbeing_domain] NVARCHAR (255) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Outcome/wellbeing_domain/main',
    FILE_FORMAT = [parquet]
    );

