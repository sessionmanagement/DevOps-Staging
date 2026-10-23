CREATE EXTERNAL TABLE [Akoranga].[mdl_context] (
    [id] BIGINT NULL,
    [context_level] BIGINT NULL,
    [instance_id] BIGINT NULL,
    [path] NVARCHAR (MAX) NULL,
    [depth] BIGINT NULL,
    [parent_id] BIGINT NULL,
    [tenant_id] BIGINT NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_context/main',
    FILE_FORMAT = [parquet]
    );

