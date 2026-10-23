CREATE EXTERNAL TABLE [Datapay].[pay_runs] (
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
    [ODSIsCurrent] INT,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1),
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Datapay/pay_runs/main',
    FILE_FORMAT = [parquet]
    );

