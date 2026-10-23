CREATE EXTERNAL TABLE [working].[EmpLive_static_shifts] (
    [id] NVARCHAR (36) NULL,
    [is_active] INT NULL,
    [name] NVARCHAR (255) NULL,
    [start_time] DATETIME2 (7) NULL,
    [end_time] DATETIME2 (7) NULL,
    [service_id] NVARCHAR (36) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/static_shifts/working',
    FILE_FORMAT = [parquet]
    );

