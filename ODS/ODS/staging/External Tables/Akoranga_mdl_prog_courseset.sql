CREATE EXTERNAL TABLE [staging].[Akoranga_mdl_prog_courseset] (
    [id] BIGINT NULL,
    [program_id] BIGINT NULL,
    [sort_order] BIGINT NULL,
    [competency_id] BIGINT NULL,
    [next_set_operator] BIGINT NULL,
    [completion_type] BIGINT NULL,
    [minimum_courses] BIGINT NULL,
    [course_sum_field] BIGINT NULL,
    [course_sum_field_total] BIGINT NULL,
    [time_allowed] BIGINT NULL,
    [recurrence_time] BIGINT NULL,
    [recurring_create_time] BIGINT NULL,
    [content_type] BIGINT NULL,
    [item_label] NVARCHAR (MAX) NULL,
    [certif_path] BIGINT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_prog_courseset/staging',
    FILE_FORMAT = [parquet]
    );

