CREATE EXTERNAL TABLE [EmpLive].[entities] (
    [id] NVARCHAR (36) NULL,
    [name] NVARCHAR (255) NULL,
    [cost_code] NVARCHAR (255) NULL,
    [ODSIsCurrent] INT,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1),
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/entities/main',
    FILE_FORMAT = [parquet]
    );

