CREATE EXTERNAL TABLE [Akoranga].[mdl_cohort_role] (
    [id] BIGINT NULL,
    [cohort_id] BIGINT NULL,
    [role_id] BIGINT NULL,
    [context_id] BIGINT NULL,
    [time_modified] BIGINT NULL,
    [time_created] BIGINT NULL,
    [user_modified] BIGINT NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_cohort_role/main',
    FILE_FORMAT = [parquet]
    );

