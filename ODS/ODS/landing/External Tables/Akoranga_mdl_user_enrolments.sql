CREATE EXTERNAL TABLE [landing].[Akoranga_mdl_user_enrolments] (
    [id] BIGINT NULL,
    [status] BIGINT NULL,
    [enrol_id] BIGINT NULL,
    [user_id] BIGINT NULL,
    [time_start] BIGINT NULL,
    [time_end] BIGINT NULL,
    [modifier_id] BIGINT NULL,
    [time_created] BIGINT NULL,
    [time_modified] BIGINT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_user_enrolments/landing',
    FILE_FORMAT = [parquet]
    );

