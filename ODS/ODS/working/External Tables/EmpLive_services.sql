CREATE EXTERNAL TABLE [working].[EmpLive_services] (
    [id] NVARCHAR (36) NULL,
    [reference_number] NVARCHAR (255) NULL,
    [name] NVARCHAR (255) NULL,
    [cost_code] NVARCHAR (255) NULL,
    [entity_id] NVARCHAR (36) NULL,
    [state] NVARCHAR (100) NULL,
    [country] NVARCHAR (100) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/services/working',
    FILE_FORMAT = [parquet]
    );

