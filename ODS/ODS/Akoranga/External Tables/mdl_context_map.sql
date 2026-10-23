CREATE EXTERNAL TABLE [Akoranga].[mdl_context_map] (
    [id] BIGINT NULL,
    [parent_id] BIGINT NULL,
    [child_id] BIGINT NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_context_map/main',
    FILE_FORMAT = [parquet]
    );

