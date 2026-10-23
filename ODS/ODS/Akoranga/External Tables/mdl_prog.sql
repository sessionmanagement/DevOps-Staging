CREATE EXTERNAL TABLE [Akoranga].[mdl_prog] (
    [id] BIGINT NULL,
    [category] BIGINT NULL,
    [sort_order] BIGINT NULL,
    [full_name] NVARCHAR (MAX) NULL,
    [short_name] NVARCHAR (MAX) NULL,
    [id_number] NVARCHAR (MAX) NULL,
    [summary] NVARCHAR (MAX) NULL,
    [end_note] NVARCHAR (MAX) NULL,
    [visible] INT NULL,
    [available_from] BIGINT NULL,
    [available_until] BIGINT NULL,
    [available] BIGINT NULL,
    [time_created] BIGINT NULL,
    [time_modified] BIGINT NULL,
    [user_modified] BIGINT NULL,
    [icon] NVARCHAR (MAX) NULL,
    [exceptions_sent] INT NULL,
    [audience_visible] INT NULL,
    [certif_id] BIGINT NULL,
    [assignments_deferred] INT NULL,
    [allow_extension_requests] INT NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_prog/main',
    FILE_FORMAT = [parquet]
    );





