CREATE EXTERNAL TABLE [landing].[Akoranga_mdl_course_categories] (
    [id] BIGINT NULL,
    [name] NVARCHAR (MAX) NULL,
    [id_number] NVARCHAR (MAX) NULL,
    [description] NVARCHAR (MAX) NULL,
    [description_format] BIGINT NULL,
    [parent] BIGINT NULL,
    [sort_order] BIGINT NULL,
    [course_count] BIGINT NULL,
    [visible] BIGINT NULL,
    [visible_old] BIGINT NULL,
    [time_modified] BIGINT NULL,
    [depth] BIGINT NULL,
    [path] NVARCHAR (MAX) NULL,
    [theme] NVARCHAR (MAX) NULL,
    [program_count] BIGINT NULL,
    [certif_count] BIGINT NULL,
    [is_system] BIGINT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_course_categories/landing',
    FILE_FORMAT = [parquet]
    );

