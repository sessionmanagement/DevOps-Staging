CREATE EXTERNAL TABLE [working].[Akoranga_mdl_facetoface_signups] (
    [id] BIGINT NULL,
    [session_id] BIGINT NULL,
    [user_id] BIGINT NULL,
    [discount_code] NVARCHAR (MAX) NULL,
    [notification_type] BIGINT NULL,
    [archived] INT NULL,
    [booked_by] BIGINT NULL,
    [job_assignment_id] BIGINT NULL,
    [manager_id] BIGINT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_facetoface_signups/working',
    FILE_FORMAT = [parquet]
    );



