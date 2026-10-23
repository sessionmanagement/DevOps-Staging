CREATE EXTERNAL TABLE [working].[EmpLive_roster_entry_pay_interpretation_time_categories] (
    [id] NVARCHAR (36) NULL,
    [roster_entry_pay_interpretation_id] NVARCHAR (36) NULL,
    [time_category_id] NVARCHAR (36) NULL,
    [duration] REAL NULL,
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
    LOCATION = N'EmpLive/roster_entry_pay_interpretation_time_categories/working',
    FILE_FORMAT = [parquet]
    );

