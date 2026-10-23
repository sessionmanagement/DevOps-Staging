CREATE EXTERNAL TABLE [landing].[Akoranga_mdl_prog_user_assignment] (
    [id] BIGINT NULL,
    [program_id] BIGINT NULL,
    [user_id] BIGINT NULL,
    [assignment_id] BIGINT NULL,
    [time_assigned] BIGINT NULL,
    [exception_status] BIGINT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_prog_user_assignment/landing',
    FILE_FORMAT = [parquet]
    );



