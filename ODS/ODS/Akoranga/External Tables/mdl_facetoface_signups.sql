CREATE EXTERNAL TABLE [Akoranga].[mdl_facetoface_signups] (
    [id] BIGINT NULL,
    [session_id] BIGINT NULL,
    [user_id] BIGINT NULL,
    [discount_code] NVARCHAR (MAX) NULL,
    [notification_type] BIGINT NULL,
    [archived] INT NULL,
    [booked_by] BIGINT NULL,
    [job_assignment_id] BIGINT NULL,
    [manager_id] BIGINT NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_facetoface_signups/main',
    FILE_FORMAT = [parquet]
    );





