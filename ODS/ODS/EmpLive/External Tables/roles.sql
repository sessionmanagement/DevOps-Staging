CREATE EXTERNAL TABLE [EmpLive].[roles] (
    [id] NVARCHAR (36) NULL,
    [is_active] INT NULL,
    [name] NVARCHAR (255) NULL,
    [cost_code] NVARCHAR (255) NULL,
    [comments] NVARCHAR (1000) NULL,
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
    LOCATION = N'EmpLive/roles/main',
    FILE_FORMAT = [parquet]
    );

