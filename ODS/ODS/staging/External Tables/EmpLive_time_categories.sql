CREATE EXTERNAL TABLE [staging].[EmpLive_time_categories] (
    [id] NVARCHAR (36) NULL,
    [name] NVARCHAR (255) NULL,
    [abbreviation] NVARCHAR (100) NULL,
    [comments] NVARCHAR (1000) NULL,
    [add_to_duration] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/time_categories/staging',
    FILE_FORMAT = [parquet]
    );

