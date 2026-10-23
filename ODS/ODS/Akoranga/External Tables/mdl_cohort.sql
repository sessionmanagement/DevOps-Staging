CREATE EXTERNAL TABLE [Akoranga].[mdl_cohort] (
    [id] BIGINT NULL,
    [context_id] BIGINT NULL,
    [name] NVARCHAR (MAX) NULL,
    [id_number] NVARCHAR (MAX) NULL,
    [description] NVARCHAR (MAX) NULL,
    [description_format] BIGINT NULL,
    [visible] BIGINT NULL,
    [component] NVARCHAR (MAX) NULL,
    [time_created] BIGINT NULL,
    [time_modified] BIGINT NULL,
    [cohort_type] BIGINT NULL,
    [modifier_id] BIGINT NULL,
    [visibility] BIGINT NULL,
    [alert_members] BIGINT NULL,
    [start_date] BIGINT NULL,
    [end_date] BIGINT NULL,
    [active] BIGINT NULL,
    [calculation_status] BIGINT NULL,
    [active_collection_id] BIGINT NULL,
    [draft_collection_id] BIGINT NULL,
    [broken] BIGINT NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_cohort/main',
    FILE_FORMAT = [parquet]
    );

