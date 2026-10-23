CREATE EXTERNAL TABLE [EmpLive].[timesheet_entry_pay_interpretation] (
    [id] NVARCHAR (36) NULL,
    [pay_level_id] NVARCHAR (36) NULL,
    [employment_type] NVARCHAR (20) NULL,
    [shift] NVARCHAR (100) NULL,
    [ODSIsCurrent] INT,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1),
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/timesheet_entry_pay_interpretation/main',
    FILE_FORMAT = [parquet]
    );

