CREATE EXTERNAL TABLE [Akoranga].[mdl_facetoface_sessions_dates] (
    [id] BIGINT NULL,
    [session_id] BIGINT NULL,
    [session_timezone] NVARCHAR (MAX) NULL,
    [time_start] BIGINT NULL,
    [time_finish] BIGINT NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_facetoface_sessions_dates/main',
    FILE_FORMAT = [parquet]
    );





