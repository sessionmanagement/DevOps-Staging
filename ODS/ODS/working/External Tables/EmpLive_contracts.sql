CREATE EXTERNAL TABLE [working].[EmpLive_contracts] (
    [id] NVARCHAR (36) NULL,
    [name] VARCHAR (255) NULL,
    [cost_code] VARCHAR (255) NULL,
    [comments] VARCHAR (1000) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/contracts/working',
    FILE_FORMAT = [parquet]
    );

