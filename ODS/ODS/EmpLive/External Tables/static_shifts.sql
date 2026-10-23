CREATE EXTERNAL TABLE [EmpLive].[static_shifts] (
    [id] NVARCHAR (36) NULL,
    [is_active] INT NULL,
    [name] NVARCHAR (255) NULL,
    [start_time] DATETIME2 (7) NULL,
    [end_time] DATETIME2 (7) NULL,
    [service_id] NVARCHAR (36) NULL,
    [ODSIsCurrent] INT,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1),
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/static_shifts/main',
    FILE_FORMAT = [parquet]
    );

