CREATE EXTERNAL TABLE [landing].[EmpLive_entities] (
    [id] NVARCHAR (36) NULL,
    [name] NVARCHAR (255) NULL,
    [cost_code] NVARCHAR (255) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/entities/landing',
    FILE_FORMAT = [parquet]
    );

