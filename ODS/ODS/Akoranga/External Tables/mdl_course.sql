CREATE EXTERNAL TABLE [Akoranga].[mdl_course] (
    [id] BIGINT NULL,
    [category] BIGINT NULL,
    [sort_order] BIGINT NULL,
    [full_name] NVARCHAR (MAX) NULL,
    [short_name] NVARCHAR (MAX) NULL,
    [id_number] NVARCHAR (MAX) NULL,
    [summary] NVARCHAR (MAX) NULL,
    [summary_format] INT NULL,
    [format] NVARCHAR (MAX) NULL,
    [show_grades] INT NULL,
    [news_items] INT NULL,
    [start_date] BIGINT NULL,
    [end_date] BIGINT NULL,
    [marker] BIGINT NULL,
    [max_bytes] BIGINT NULL,
    [legacy_files] INT NULL,
    [show_reports] INT NULL,
    [visible] INT NULL,
    [visible_old] INT NULL,
    [group_mode] INT NULL,
    [group_mode_force] INT NULL,
    [default_grouping_id] BIGINT NULL,
    [lang] NVARCHAR (MAX) NULL,
    [calendar_type] NVARCHAR (MAX) NULL,
    [theme] NVARCHAR (MAX) NULL,
    [time_created] BIGINT NULL,
    [time_modified] BIGINT NULL,
    [requested] INT NULL,
    [enable_completion] INT NULL,
    [completion_start_on_enrol] INT NULL,
    [completion_progress_on_view] INT NULL,
    [completion_notify] INT NULL,
    [audience_visible] INT NULL,
    [cache_rev] BIGINT NULL,
    [course_type] INT NULL,
    [icon] NVARCHAR (MAX) NULL,
    [container_type] NVARCHAR (MAX) NULL,
    [due_date] BIGINT NULL,
    [due_date_offset_unit] INT NULL,
    [due_date_offset_amount] INT NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_course/main',
    FILE_FORMAT = [parquet]
    );





