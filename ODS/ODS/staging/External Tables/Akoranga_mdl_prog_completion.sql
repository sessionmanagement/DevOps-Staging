CREATE EXTERNAL TABLE [staging].[Akoranga_mdl_prog_completion] (
    [id] BIGINT NULL,
    [program_id] BIGINT NULL,
    [user_id] BIGINT NULL,
    [course_set_id] BIGINT NULL,
    [certif_status] BIGINT NULL,
    [time_started] BIGINT NULL,
    [time_due] BIGINT NULL,
    [time_completed] BIGINT NULL,
    [organisation_id] BIGINT NULL,
    [position_id] BIGINT NULL,
    [time_created] BIGINT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_prog_completion/staging',
    FILE_FORMAT = [parquet]
    );

