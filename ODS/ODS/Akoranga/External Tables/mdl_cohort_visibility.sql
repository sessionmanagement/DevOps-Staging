CREATE EXTERNAL TABLE [Akoranga].[mdl_cohort_visibility] (
    [id] BIGINT NULL,
    [cohort_id] BIGINT NULL,
    [instance_id] BIGINT NULL,
    [instance_type] BIGINT NULL,
    [time_modified] BIGINT NULL,
    [time_created] BIGINT NULL,
    [user_modified] BIGINT NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_cohort_visibility/main',
    FILE_FORMAT = [parquet]
    );

