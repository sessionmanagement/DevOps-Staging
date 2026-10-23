CREATE EXTERNAL TABLE [landing].[EmpLive_allowances] (
    [id] NVARCHAR (36) NULL,
    [name] NVARCHAR (255) NULL,
    [abbreviation] NVARCHAR (255) NULL,
    [comments] NVARCHAR (1000) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/allowances/landing',
    FILE_FORMAT = [parquet]
    );

