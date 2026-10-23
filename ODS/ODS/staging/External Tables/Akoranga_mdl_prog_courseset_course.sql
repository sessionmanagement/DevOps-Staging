CREATE EXTERNAL TABLE [staging].[Akoranga_mdl_prog_courseset_course] (
    [id] BIGINT NULL,
    [courseset_id] BIGINT NULL,
    [course_id] BIGINT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_prog_courseset_course/staging',
    FILE_FORMAT = [parquet]
    );

