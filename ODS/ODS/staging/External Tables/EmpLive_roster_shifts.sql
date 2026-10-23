CREATE EXTERNAL TABLE [staging].[EmpLive_roster_shifts] (
    [id] NVARCHAR (36) NULL,
    [service_name_id] NVARCHAR (36) NULL,
    [job_id] NVARCHAR (36) NULL,
    [role_id] NVARCHAR (36) NULL,
    [static_shift_id] NVARCHAR (36) NULL,
    [start_date] DATETIME2 (7) NULL,
    [start_time] DATETIME2 (7) NULL,
    [end_date] DATETIME2 (7) NULL,
    [end_time] DATETIME2 (7) NULL,
    [employees_required] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/roster_shifts/staging',
    FILE_FORMAT = [parquet]
    );

