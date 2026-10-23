CREATE EXTERNAL TABLE [working].[On_Call_region] (
    [region_id] INT NULL,
    [region] NVARCHAR (50) NULL,
    [region_name] NVARCHAR (50) NULL,
    [is_active] NVARCHAR (10) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'On_Call/region/working',
    FILE_FORMAT = [parquet]
    );

