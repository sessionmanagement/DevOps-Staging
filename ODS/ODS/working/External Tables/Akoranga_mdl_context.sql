CREATE EXTERNAL TABLE [working].[Akoranga_mdl_context] (
    [id] BIGINT NULL,
    [context_level] BIGINT NULL,
    [instance_id] BIGINT NULL,
    [path] NVARCHAR (MAX) NULL,
    [depth] BIGINT NULL,
    [parent_id] BIGINT NULL,
    [tenant_id] BIGINT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_context/working',
    FILE_FORMAT = [parquet]
    );

