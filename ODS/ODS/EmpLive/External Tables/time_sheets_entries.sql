CREATE EXTERNAL TABLE [EmpLive].[time_sheets_entries] (
    [id] NVARCHAR (36) NULL,
    [service_name_id] NVARCHAR (36) NULL,
    [job_id] NVARCHAR (50) NULL,
    [role_id] NVARCHAR (36) NULL,
    [work_type_id] NVARCHAR (36) NULL,
    [employee_id] NVARCHAR (36) NULL,
    [start_date] DATETIME2 (7) NULL,
    [start_time] DATETIME2 (7) NULL,
    [end_date] DATETIME2 (7) NULL,
    [end_time] DATETIME2 (7) NULL,
    [actual_start_date] DATETIME2 (7) NULL,
    [actual_start_time] DATETIME2 (7) NULL,
    [actual_end_date] DATETIME2 (7) NULL,
    [actual_end_time] DATETIME2 (7) NULL,
    [comments] NVARCHAR (1000) NULL,
    [approval_status] NVARCHAR (100) NULL,
    [clocking_start_id] NVARCHAR (36) NULL,
    [clocking_end_id] NVARCHAR (36) NULL,
    [pay_interpretation_id] NVARCHAR (36) NULL,
    [roster_entry_id] NVARCHAR (36) NULL,
    [ODSIsCurrent] INT,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1),
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/time_sheets_entries/main',
    FILE_FORMAT = [parquet]
    );

