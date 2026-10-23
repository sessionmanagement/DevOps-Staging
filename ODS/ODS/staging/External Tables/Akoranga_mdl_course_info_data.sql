CREATE EXTERNAL TABLE [staging].[Akoranga_mdl_course_info_data] (
    [id] BIGINT NULL,
    [field_id] BIGINT NULL,
    [course_id] BIGINT NULL,
    [data] NVARCHAR (MAX) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_course_info_data/staging',
    FILE_FORMAT = [parquet]
    );

