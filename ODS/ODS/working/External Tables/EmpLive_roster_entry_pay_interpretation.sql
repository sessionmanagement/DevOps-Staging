CREATE EXTERNAL TABLE [working].[EmpLive_roster_entry_pay_interpretation] (
    [id] NVARCHAR (36) NULL,
    [pay_level_id] NVARCHAR (36) NULL,
    [employment_type] NVARCHAR (10) NULL,
    [shift] NVARCHAR (10) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'EmpLive/roster_entry_pay_interpretation/working',
    FILE_FORMAT = [parquet]
    );

