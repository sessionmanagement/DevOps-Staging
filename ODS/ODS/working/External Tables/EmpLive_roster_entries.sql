CREATE EXTERNAL TABLE [working].[EmpLive_roster_entries] (
    [id] NVARCHAR (36) NULL,
    [roster_shift_id] NVARCHAR (36) NULL,
    [employee_id] NVARCHAR (36) NULL,
    [roster_code_id] NVARCHAR (36) NULL,
    [pay_interpretation_id] NVARCHAR (36) NULL,
    [roster_rule_override_reason] NVARCHAR (255) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/roster_entries/working',
    FILE_FORMAT = [parquet]
    );

