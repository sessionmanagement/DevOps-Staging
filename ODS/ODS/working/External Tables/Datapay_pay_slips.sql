CREATE EXTERNAL TABLE [working].[Datapay_pay_slips] (
    [pay_packet_id] INT NULL,
    [employee_id] NVARCHAR (50) NULL,
    [gross_pay_total_amount] FLOAT (53) NULL,
    [deductions_total_amount] FLOAT (53) NULL,
    [net_pay_total_amount] FLOAT (53) NULL,
    [dc_date] DATE NULL,
    [pay_period_start_date] DATE NULL,
    [pay_period_end_date] DATE NULL,
    [pay_packet_type] NVARCHAR (50) NULL,
    [file_path] NVARCHAR (1024) NULL,
    [company_id] NVARCHAR (1024) NULL,
    [filename] NVARCHAR (1024) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Datapay/pay_slips/working',
    FILE_FORMAT = [parquet]
    );

