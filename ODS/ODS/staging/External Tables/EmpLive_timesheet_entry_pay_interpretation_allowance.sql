CREATE EXTERNAL TABLE [staging].[EmpLive_timesheet_entry_pay_interpretation_allowance] (
    [id] NVARCHAR (36) NULL,
    [timesheet_entry_pay_interpretation_id] NVARCHAR (36) NULL,
    [allowance_id] NVARCHAR (36) NULL,
    [quantity] REAL NULL,
    [actual_quantity] REAL NULL,
    [pay] REAL NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/timesheet_entry_pay_interpretation_allowance/staging',
    FILE_FORMAT = [parquet]
    );

