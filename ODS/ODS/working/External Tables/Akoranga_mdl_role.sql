CREATE EXTERNAL TABLE [working].[Akoranga_mdl_role] (
    [id] BIGINT NULL,
    [name] NVARCHAR (MAX) NULL,
    [short_name] NVARCHAR (MAX) NULL,
    [description] NVARCHAR (MAX) NULL,
    [sort_order] BIGINT NULL,
    [archetype_id] NVARCHAR (MAX) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_role/working',
    FILE_FORMAT = [parquet]
    );

