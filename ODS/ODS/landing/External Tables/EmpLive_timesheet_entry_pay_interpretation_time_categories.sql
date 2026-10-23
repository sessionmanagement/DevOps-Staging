CREATE EXTERNAL TABLE [landing].[EmpLive_timesheet_entry_pay_interpretation_time_categories] (
    [id] NVARCHAR (36) NULL,
    [timesheet_entry_pay_interpretation_id] NVARCHAR (36) NULL,
    [time_category_id] NVARCHAR (36) NULL,
    [duration] REAL NULL,
    [pay] REAL NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/timesheet_entry_pay_interpretation_time_categories/landing',
    FILE_FORMAT = [parquet]
    );

