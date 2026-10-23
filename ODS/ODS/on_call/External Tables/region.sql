CREATE EXTERNAL TABLE [on_call].[region] (
    [region_id] INT NULL,
    [region] NVARCHAR (50) NULL,
    [region_name] NVARCHAR (50) NULL,
    [is_active] NVARCHAR (10) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'On_Call/region/main',
    FILE_FORMAT = [parquet]
    );

