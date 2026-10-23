CREATE EXTERNAL TABLE [working].[Datapay_pay_slips_deductions] (
    [pay_packet_row_id] NVARCHAR (4000) NULL,
    [pay_packet_id] NVARCHAR (4000) NULL,
    [employee_id] NVARCHAR (4000) NULL,
    [deductions_amount] FLOAT (53) NULL,
    [deductions_name] NVARCHAR (100) NULL,
    [deduction_summary] NVARCHAR (500) NULL,
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
    LOCATION = N'Datapay/pay_slips_deductions/working',
    FILE_FORMAT = [parquet]
    );

