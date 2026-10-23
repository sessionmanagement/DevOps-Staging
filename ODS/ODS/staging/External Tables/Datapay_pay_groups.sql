CREATE EXTERNAL TABLE [staging].[Datapay_pay_groups] (
    [company_id] NVARCHAR (500) NULL,
    [paygroup_id] NVARCHAR (500) NULL,
    [code] NVARCHAR (500) NULL,
    [name] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Datapay/pay_groups/staging',
    FILE_FORMAT = [parquet]
    );

