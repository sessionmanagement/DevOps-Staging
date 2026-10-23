CREATE EXTERNAL TABLE [EmpLive].[contracts] (
    [id] NVARCHAR (36) NULL,
    [name] VARCHAR (255) NULL,
    [cost_code] VARCHAR (255) NULL,
    [comments] VARCHAR (1000) NULL,
    [ODSIsCurrent] INT,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1),
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/contracts/main',
    FILE_FORMAT = [parquet]
    );

