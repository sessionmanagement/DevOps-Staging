CREATE EXTERNAL TABLE [landing].[EmpLive_timesheet_entry_pay_interpretation] (
    [id] NVARCHAR (36) NULL,
    [pay_level_id] NVARCHAR (36) NULL,
    [employment_type] NVARCHAR (20) NULL,
    [shift] NVARCHAR (100) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/timesheet_entry_pay_interpretation/landing',
    FILE_FORMAT = [parquet]
    );

