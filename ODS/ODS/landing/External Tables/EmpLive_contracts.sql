CREATE EXTERNAL TABLE [landing].[EmpLive_contracts] (
    [id] NVARCHAR (36) NULL,
    [name] VARCHAR (255) NULL,
    [cost_code] VARCHAR (255) NULL,
    [comments] VARCHAR (1000) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/contracts/landing',
    FILE_FORMAT = [parquet]
    );

