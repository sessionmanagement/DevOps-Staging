CREATE EXTERNAL TABLE [DataPay].[pay_slips_gross] (
    [pay_packet_row_id] NVARCHAR (4000) NULL,
    [pay_packet_id] INT NULL,
    [employee_id] NVARCHAR (4000) NULL,
    [gross_amount] FLOAT (53) NULL,
    [gross_name] NVARCHAR (100) NULL,
    [gross_summary] NVARCHAR (4000) NULL,
    [file_path] NVARCHAR (1024) NULL,
    [company_id] NVARCHAR (1024) NULL,
    [filename] NVARCHAR (1024) NULL,
    [ODSIsCurrent] INT NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1) NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Datapay/pay_slips_gross/main',
    FILE_FORMAT = [delta]
    );

