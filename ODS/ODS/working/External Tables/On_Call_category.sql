CREATE EXTERNAL TABLE [working].[On_Call_category] (
    [category_id] INT NULL,
    [category_name] NVARCHAR (50) NULL,
    [category_description] NVARCHAR (200) NULL,
    [ODSSourceSystem] NVARCHAR (100) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'On_Call/category/working',
    FILE_FORMAT = [parquet]
    );

