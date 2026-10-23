CREATE EXTERNAL TABLE [landing].[EmpLive_work_types] (
    [id] NVARCHAR (36) NULL,
    [name] NVARCHAR (255) NULL,
    [abbreviation] NVARCHAR (100) NULL,
    [is_leave] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/work_types/landing',
    FILE_FORMAT = [parquet]
    );

