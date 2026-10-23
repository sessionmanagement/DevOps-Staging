CREATE EXTERNAL TABLE [working].[EmpLive_timesheet_entry_pay_interpretation_allowance] (
    [id] NVARCHAR (36) NULL,
    [timesheet_entry_pay_interpretation_id] NVARCHAR (36) NULL,
    [allowance_id] NVARCHAR (36) NULL,
    [quantity] REAL NULL,
    [actual_quantity] REAL NULL,
    [pay] REAL NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/timesheet_entry_pay_interpretation_allowance/working',
    FILE_FORMAT = [parquet]
    );

