CREATE EXTERNAL TABLE [working].[EmpLive_roles] (
    [id] NVARCHAR (36) NULL,
    [is_active] INT NULL,
    [name] NVARCHAR (255) NULL,
    [cost_code] NVARCHAR (255) NULL,
    [comments] NVARCHAR (1000) NULL,
    [contract_id] NVARCHAR (36) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/roles/working',
    FILE_FORMAT = [parquet]
    );

