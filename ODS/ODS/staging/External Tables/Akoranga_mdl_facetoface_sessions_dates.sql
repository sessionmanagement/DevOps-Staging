CREATE EXTERNAL TABLE [staging].[Akoranga_mdl_facetoface_sessions_dates] (
    [id] BIGINT NULL,
    [session_id] BIGINT NULL,
    [session_timezone] NVARCHAR (MAX) NULL,
    [time_start] BIGINT NULL,
    [time_finish] BIGINT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_facetoface_sessions_dates/staging',
    FILE_FORMAT = [parquet]
    );



