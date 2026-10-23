CREATE EXTERNAL TABLE [EmpLive].[pay_levels] (
    [id] NVARCHAR (36) NULL,
    [name] NVARCHAR (255) NULL,
    [cost_code] NVARCHAR (50) NULL,
    [contract_id] NVARCHAR (36) NULL,
    [ODSIsCurrent] INT,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1),
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/pay_levels/main',
    FILE_FORMAT = [parquet]
    );

