CREATE EXTERNAL TABLE [Akoranga].[mdl_cohort_members] (
    [id] BIGINT NULL,
    [cohort_id] BIGINT NULL,
    [user_id] BIGINT NULL,
    [time_added] BIGINT NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_cohort_members/main',
    FILE_FORMAT = [parquet]
    );

