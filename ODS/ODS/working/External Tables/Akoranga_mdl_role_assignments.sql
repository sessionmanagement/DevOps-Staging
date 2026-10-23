CREATE EXTERNAL TABLE [working].[Akoranga_mdl_role_assignments] (
    [id] BIGINT NULL,
    [role_id] BIGINT NULL,
    [context_id] BIGINT NULL,
    [user_id] BIGINT NULL,
    [time_modified] BIGINT NULL,
    [modifier_id] BIGINT NULL,
    [component] NVARCHAR (MAX) NULL,
    [item_id] BIGINT NULL,
    [sortorder] BIGINT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_role_assignments/working',
    FILE_FORMAT = [parquet]
    );

