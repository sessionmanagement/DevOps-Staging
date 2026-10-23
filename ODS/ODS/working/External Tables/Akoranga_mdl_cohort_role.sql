CREATE EXTERNAL TABLE [working].[Akoranga_mdl_cohort_role] (
    [id] BIGINT NULL,
    [cohort_id] BIGINT NULL,
    [role_id] BIGINT NULL,
    [context_id] BIGINT NULL,
    [time_modified] BIGINT NULL,
    [time_created] BIGINT NULL,
    [user_modified] BIGINT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_cohort_role/working',
    FILE_FORMAT = [parquet]
    );

