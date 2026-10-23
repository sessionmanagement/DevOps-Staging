CREATE EXTERNAL TABLE [working].[Akoranga_mdl_context_map] (
    [id] BIGINT NULL,
    [parent_id] BIGINT NULL,
    [child_id] BIGINT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_context_map/working',
    FILE_FORMAT = [parquet]
    );

