CREATE EXTERNAL TABLE [Akoranga].[mdl_role] (
    [id] BIGINT NULL,
    [name] NVARCHAR (MAX) NULL,
    [short_name] NVARCHAR (MAX) NULL,
    [description] NVARCHAR (MAX) NULL,
    [sort_order] BIGINT NULL,
    [archetype_id] NVARCHAR (MAX) NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_role/main',
    FILE_FORMAT = [parquet]
    );

