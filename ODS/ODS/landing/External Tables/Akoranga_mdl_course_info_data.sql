CREATE EXTERNAL TABLE [landing].[Akoranga_mdl_course_info_data] (
    [id] BIGINT NULL,
    [field_id] BIGINT NULL,
    [course_id] BIGINT NULL,
    [data] NVARCHAR (MAX) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_course_info_data/landing',
    FILE_FORMAT = [parquet]
    );

