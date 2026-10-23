CREATE EXTERNAL TABLE [working].[Datapay_pay_runs] (
    [pay_run_id] INT NULL,
    [pay_group_id] NVARCHAR (50) NULL,
    [run_type] NVARCHAR (50) NULL,
    [status] NVARCHAR (20) NULL,
    [locked] INT NULL,
    [finalisation_date] DATETIME2 (7) NULL,
    [dc_date] DATE NULL,
    [exclude_from_banking] INT NULL,
    [pay_period_start_date] DATE NULL,
    [pay_period_end_date] DATE NULL,
    [process_timestamp] DATETIME2 (7) NULL,
    [filepath] NVARCHAR (1024) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Datapay/pay_runs/working',
    FILE_FORMAT = [parquet]
    );

