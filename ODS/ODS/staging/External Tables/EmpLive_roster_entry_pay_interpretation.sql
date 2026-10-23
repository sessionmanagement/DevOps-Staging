CREATE EXTERNAL TABLE [staging].[EmpLive_roster_entry_pay_interpretation] (
    [id] NVARCHAR (36) NULL,
    [pay_level_id] NVARCHAR (36) NULL,
    [employment_type] NVARCHAR (10) NULL,
    [shift] NVARCHAR (10) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/roster_entry_pay_interpretation/staging',
    FILE_FORMAT = [parquet]
    );

