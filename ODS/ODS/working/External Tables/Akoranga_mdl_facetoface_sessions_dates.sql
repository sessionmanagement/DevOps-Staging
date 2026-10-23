CREATE EXTERNAL TABLE [working].[Akoranga_mdl_facetoface_sessions_dates] (
    [id] BIGINT NULL,
    [session_id] BIGINT NULL,
    [session_timezone] NVARCHAR (MAX) NULL,
    [time_start] BIGINT NULL,
    [time_finish] BIGINT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_facetoface_sessions_dates/working',
    FILE_FORMAT = [parquet]
    );



