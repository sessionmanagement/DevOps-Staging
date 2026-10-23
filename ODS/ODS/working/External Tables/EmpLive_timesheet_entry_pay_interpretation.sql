CREATE EXTERNAL TABLE [working].[EmpLive_timesheet_entry_pay_interpretation] (
    [id] NVARCHAR (36) NULL,
    [pay_level_id] NVARCHAR (36) NULL,
    [employment_type] NVARCHAR (20) NULL,
    [shift] NVARCHAR (100) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/timesheet_entry_pay_interpretation/working',
    FILE_FORMAT = [parquet]
    );

