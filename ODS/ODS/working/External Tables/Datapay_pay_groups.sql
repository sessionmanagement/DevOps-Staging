CREATE EXTERNAL TABLE [working].[Datapay_pay_groups] (
    [company_id] NVARCHAR (500) NULL,
    [paygroup_id] NVARCHAR (500) NULL,
    [code] NVARCHAR (500) NULL,
    [name] NVARCHAR (500) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Datapay/pay_groups/working',
    FILE_FORMAT = [parquet]
    );

