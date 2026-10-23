CREATE EXTERNAL TABLE [EmpLive].[timesheet_entry_pay_interpretation_allowance] (
    [id] NVARCHAR (36) NULL,
    [timesheet_entry_pay_interpretation_id] NVARCHAR (36) NULL,
    [allowance_id] NVARCHAR (36) NULL,
    [quantity] REAL NULL,
    [actual_quantity] REAL NULL,
    [pay] REAL NULL,
    [ODSIsCurrent] INT,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1),
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/timesheet_entry_pay_interpretation_allowance/main',
    FILE_FORMAT = [parquet]
    );

