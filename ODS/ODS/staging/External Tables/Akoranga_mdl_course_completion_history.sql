CREATE EXTERNAL TABLE [staging].[Akoranga_mdl_course_completion_history] (
    [id] BIGINT NULL,
    [course_id] BIGINT NULL,
    [user_id] BIGINT NULL,
    [time_completed] BIGINT NULL,
    [grade] NUMERIC (18) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_course_completion_history/staging',
    FILE_FORMAT = [parquet]
    );

