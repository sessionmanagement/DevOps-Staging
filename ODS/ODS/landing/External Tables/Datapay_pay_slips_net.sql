CREATE EXTERNAL TABLE [landing].[Datapay_pay_slips_net] (
    [pay_packet_row_id] NVARCHAR (4000) NULL,
    [pay_packet_id] NVARCHAR (4000) NULL,
    [employee_id] NVARCHAR (4000) NULL,
    [net_pay_amount] FLOAT (53) NULL,
    [net_pay_name] NVARCHAR (100) NULL,
    [net_pay_summary] NVARCHAR (500) NULL,
    [file_path] NVARCHAR (1024) NULL,
    [company_id] NVARCHAR (1024) NULL,
    [filename] NVARCHAR (1024) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Datapay/pay_slips_net/landing',
    FILE_FORMAT = [parquet]
    );

