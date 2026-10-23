CREATE EXTERNAL TABLE [on_call].[category] (
    [category_id] INT NULL,
    [category_name] NVARCHAR (50) NULL,
    [category_description] NVARCHAR (200) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'On_Call/category/main',
    FILE_FORMAT = [parquet]
    );

