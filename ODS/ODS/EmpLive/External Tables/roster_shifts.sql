CREATE EXTERNAL TABLE [EmpLive].[roster_shifts] (
    [id] NVARCHAR (36) NULL,
    [service_name_id] NVARCHAR (36) NULL,
    [job_id] NVARCHAR (36) NULL,
    [role_id] NVARCHAR (36) NULL,
    [static_shift_id] NVARCHAR (36) NULL,
    [start_date] DATETIME2 (7) NULL,
    [start_time] DATETIME2 (7) NULL,
    [end_date] DATETIME2 (7) NULL,
    [end_time] DATETIME2 (7) NULL,
    [employees_required] INT NULL,
    [ODSIsCurrent] INT,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1),
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/roster_shifts/main',
    FILE_FORMAT = [parquet]
    );

