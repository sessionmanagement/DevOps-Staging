CREATE EXTERNAL TABLE [Akoranga].[mdl_certif_completion_history] (
    [id] BIGINT NULL,
    [certif_id] BIGINT NULL,
    [user_id] BIGINT NULL,
    [certif_path] BIGINT NULL,
    [certif_status] BIGINT NULL,
    [renewal_status] BIGINT NULL,
    [time_window_opens] BIGINT NULL,
    [time_expires] BIGINT NULL,
    [baseline_time_expires] BIGINT NULL,
    [time_completed] BIGINT NULL,
    [time_modified] BIGINT NULL,
    [unassigned] BIGINT NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Akoranga/mdl_certif_completion_history/main',
    FILE_FORMAT = [parquet]
    );

