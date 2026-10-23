CREATE EXTERNAL TABLE [Datapay].[leave_balances] (
    [employee_id] NVARCHAR (50) NULL,
    [leave_type_id] NVARCHAR (50) NULL,
    [effective_date] DATETIME2 (7) NULL,
    [unit] NVARCHAR (50) NULL,
    [entitlement] REAL NULL,
    [accrual] REAL NULL,
    [taken] REAL NULL,
    [balance] REAL NULL,
    [anniversary] DATETIME2 (7) NULL,
    [next_entitlement] REAL NULL,
    [ODSIsCurrent] INT,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1),
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Datapay/leave_balances/main',
    FILE_FORMAT = [parquet]
    );

