CREATE EXTERNAL TABLE [landing].[EmpLive_static_shifts] (
    [id] NVARCHAR (36) NULL,
    [is_active] INT NULL,
    [name] NVARCHAR (255) NULL,
    [start_time] DATETIME2 (7) NULL,
    [end_time] DATETIME2 (7) NULL,
    [service_id] NVARCHAR (36) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/static_shifts/landing',
    FILE_FORMAT = [parquet]
    );

