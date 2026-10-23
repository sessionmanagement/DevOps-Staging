CREATE EXTERNAL TABLE [landing].[Akoranga_mdl_facetoface_signups] (
    [id] BIGINT NULL,
    [session_id] BIGINT NULL,
    [user_id] BIGINT NULL,
    [discount_code] NVARCHAR (MAX) NULL,
    [notification_type] BIGINT NULL,
    [archived] INT NULL,
    [booked_by] BIGINT NULL,
    [job_assignment_id] BIGINT NULL,
    [manager_id] BIGINT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_facetoface_signups/landing',
    FILE_FORMAT = [parquet]
    );



