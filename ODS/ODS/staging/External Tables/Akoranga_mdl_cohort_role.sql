CREATE EXTERNAL TABLE [staging].[Akoranga_mdl_cohort_role] (
    [id] BIGINT NULL,
    [cohort_id] BIGINT NULL,
    [role_id] BIGINT NULL,
    [context_id] BIGINT NULL,
    [time_modified] BIGINT NULL,
    [time_created] BIGINT NULL,
    [user_modified] BIGINT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_cohort_role/staging',
    FILE_FORMAT = [parquet]
    );

