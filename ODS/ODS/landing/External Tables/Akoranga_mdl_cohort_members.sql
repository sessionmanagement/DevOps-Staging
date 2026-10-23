CREATE EXTERNAL TABLE [landing].[Akoranga_mdl_cohort_members] (
    [id] BIGINT NULL,
    [cohort_id] BIGINT NULL,
    [user_id] BIGINT NULL,
    [time_added] BIGINT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_cohort_members/landing',
    FILE_FORMAT = [parquet]
    );

