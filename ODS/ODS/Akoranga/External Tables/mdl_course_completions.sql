CREATE EXTERNAL TABLE [Akoranga].[mdl_course_completions] (
    [id] BIGINT NULL,
    [user_id] BIGINT NULL,
    [course] BIGINT NULL,
    [organisation_id] BIGINT NULL,
    [position_id] BIGINT NULL,
    [time_enrolled] BIGINT NULL,
    [time_started] BIGINT NULL,
    [time_completed] BIGINT NULL,
    [reaggregate] BIGINT NULL,
    [rpl] NVARCHAR (MAX) NULL,
    [rpl_grade] NUMERIC (38, 18) NULL,
    [invalidate_cache] INT NULL,
    [status] INT NULL,
    [renewal_status] INT NULL,
    [due_date] BIGINT NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_course_completions/main',
    FILE_FORMAT = [parquet]
    );





