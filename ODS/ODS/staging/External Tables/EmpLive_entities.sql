CREATE EXTERNAL TABLE [staging].[EmpLive_entities] (
    [id] NVARCHAR (36) NULL,
    [name] NVARCHAR (255) NULL,
    [cost_code] NVARCHAR (255) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/entities/staging',
    FILE_FORMAT = [parquet]
    );

