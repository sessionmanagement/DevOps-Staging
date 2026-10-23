CREATE EXTERNAL TABLE [Akoranga].[mdl_certif_completion] (
    [id] BIGINT NULL,
    [certif_id] BIGINT NULL,
    [user_id] BIGINT NULL,
    [certif_path] INT NULL,
    [status] INT NULL,
    [renewal_status] INT NULL,
    [time_window_opens] BIGINT NULL,
    [time_expires] BIGINT NULL,
    [baseline_time_expires] BIGINT NULL,
    [time_completed] BIGINT NULL,
    [time_modified] BIGINT NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_certif_completion/main',
    FILE_FORMAT = [parquet]
    );









