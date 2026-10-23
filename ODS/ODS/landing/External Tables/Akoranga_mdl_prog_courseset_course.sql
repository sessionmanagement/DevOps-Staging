CREATE EXTERNAL TABLE [landing].[Akoranga_mdl_prog_courseset_course] (
    [id] BIGINT NULL,
    [courseset_id] BIGINT NULL,
    [course_id] BIGINT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_prog_courseset_course/landing',
    FILE_FORMAT = [parquet]
    );

