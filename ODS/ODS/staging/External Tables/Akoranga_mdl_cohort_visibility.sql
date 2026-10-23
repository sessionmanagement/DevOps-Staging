CREATE EXTERNAL TABLE [staging].[Akoranga_mdl_cohort_visibility] (
    [id] BIGINT NULL,
    [cohort_id] BIGINT NULL,
    [instance_id] BIGINT NULL,
    [instance_type] BIGINT NULL,
    [time_modified] BIGINT NULL,
    [time_created] BIGINT NULL,
    [user_modified] BIGINT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_cohort_visibility/staging',
    FILE_FORMAT = [parquet]
    );

