CREATE EXTERNAL TABLE [Akoranga].[mdl_course_completion_history] (
    [id] BIGINT NULL,
    [course_id] BIGINT NULL,
    [user_id] BIGINT NULL,
    [time_completed] BIGINT NULL,
    [grade] NUMERIC (18) NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_course_completion_history/main',
    FILE_FORMAT = [parquet]
    );

