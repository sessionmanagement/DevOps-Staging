CREATE EXTERNAL TABLE [working].[Akoranga_mdl_course_completion_history] (
    [id] BIGINT NULL,
    [course_id] BIGINT NULL,
    [user_id] BIGINT NULL,
    [time_completed] BIGINT NULL,
    [grade] NUMERIC (18) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_course_completion_history/working',
    FILE_FORMAT = [parquet]
    );

