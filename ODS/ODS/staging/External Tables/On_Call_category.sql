CREATE EXTERNAL TABLE [staging].[On_Call_category] (
    [category_id] INT NULL,
    [category_name] NVARCHAR (50) NULL,
    [category_description] NVARCHAR (200) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'On_Call/category/staging',
    FILE_FORMAT = [parquet]
    );

