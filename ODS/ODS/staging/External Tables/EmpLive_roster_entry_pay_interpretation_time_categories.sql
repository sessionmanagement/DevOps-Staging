CREATE EXTERNAL TABLE [staging].[EmpLive_roster_entry_pay_interpretation_time_categories] (
    [id] NVARCHAR (36) NULL,
    [roster_entry_pay_interpretation_id] NVARCHAR (36) NULL,
    [time_category_id] NVARCHAR (36) NULL,
    [duration] REAL NULL,
    [pay] REAL NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/roster_entry_pay_interpretation_time_categories/staging',
    FILE_FORMAT = [parquet]
    );

