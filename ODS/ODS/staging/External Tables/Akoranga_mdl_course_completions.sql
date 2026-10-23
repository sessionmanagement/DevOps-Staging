CREATE EXTERNAL TABLE [staging].[Akoranga_mdl_course_completions] (
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
    [due_date] BIGINT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_course_completions/staging',
    FILE_FORMAT = [parquet]
    );



