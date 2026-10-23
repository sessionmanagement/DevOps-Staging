CREATE EXTERNAL TABLE [EmpLive].[roster_entries] (
    [id] NVARCHAR (36) NULL,
    [roster_shift_id] NVARCHAR (36) NULL,
    [employee_id] NVARCHAR (36) NULL,
    [roster_code_id] NVARCHAR (36) NULL,
    [pay_interpretation_id] NVARCHAR (36) NULL,
    [roster_rule_override_reason] NVARCHAR (255) NULL,
    [ODSIsCurrent] INT,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1),
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/roster_entries/main',
    FILE_FORMAT = [parquet]
    );

