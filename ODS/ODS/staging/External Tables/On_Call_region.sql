CREATE EXTERNAL TABLE [staging].[On_Call_region] (
    [region_id] INT NULL,
    [region] NVARCHAR (50) NULL,
    [region_name] NVARCHAR (50) NULL,
    [is_active] NVARCHAR (10) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'On_Call/region/staging',
    FILE_FORMAT = [parquet]
    );

