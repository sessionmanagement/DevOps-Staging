CREATE EXTERNAL TABLE [landing].[Datapay_leave_balances] (
    [employee_id] NVARCHAR (50) NULL,
    [leave_type_id] NVARCHAR (50) NULL,
    [effective_date] DATETIME2 (7) NULL,
    [unit] NVARCHAR (50) NULL,
    [entitlement] REAL NULL,
    [accrual] REAL NULL,
    [taken] REAL NULL,
    [balance] REAL NULL,
    [anniversary] DATETIME2 (7) NULL,
    [next_entitlement] REAL NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Datapay/leave_balances/landing',
    FILE_FORMAT = [parquet]
    );

