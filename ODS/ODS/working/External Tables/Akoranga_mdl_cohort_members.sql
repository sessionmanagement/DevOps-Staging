CREATE EXTERNAL TABLE [working].[Akoranga_mdl_cohort_members] (
    [id] BIGINT NULL,
    [cohort_id] BIGINT NULL,
    [user_id] BIGINT NULL,
    [time_added] BIGINT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_cohort_members/working',
    FILE_FORMAT = [parquet]
    );

