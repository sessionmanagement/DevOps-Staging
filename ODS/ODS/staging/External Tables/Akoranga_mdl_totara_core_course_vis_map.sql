CREATE EXTERNAL TABLE [staging].[Akoranga_mdl_totara_core_course_vis_map] (
    [id] BIGINT NULL,
    [course_id] BIGINT NULL,
    [role_id] BIGINT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_totara_core_course_vis_map/staging',
    FILE_FORMAT = [parquet]
    );

