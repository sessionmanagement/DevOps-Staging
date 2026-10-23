CREATE EXTERNAL TABLE [Akoranga].[mdl_role_assignments] (
    [id] BIGINT NULL,
    [role_id] BIGINT NULL,
    [context_id] BIGINT NULL,
    [user_id] BIGINT NULL,
    [time_modified] BIGINT NULL,
    [modifier_id] BIGINT NULL,
    [component] NVARCHAR (MAX) NULL,
    [item_id] BIGINT NULL,
    [sortorder] BIGINT NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_role_assignments/main',
    FILE_FORMAT = [parquet]
    );

