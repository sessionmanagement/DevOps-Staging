CREATE EXTERNAL TABLE [EmpLive].[timesheet_entry_pay_interpretation_time_categories] (
    [id] NVARCHAR (36) NULL,
    [timesheet_entry_pay_interpretation_id] NVARCHAR (36) NULL,
    [time_category_id] NVARCHAR (36) NULL,
    [duration] REAL NULL,
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
    LOCATION = N'EmpLive/timesheet_entry_pay_interpretation_time_categories/main',
    FILE_FORMAT = [parquet]
    );

