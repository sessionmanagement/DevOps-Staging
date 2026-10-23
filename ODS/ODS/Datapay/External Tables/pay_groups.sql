CREATE EXTERNAL TABLE [Datapay].[pay_groups] (
    [company_id] NVARCHAR (500) NULL,
    [paygroup_id] NVARCHAR (500) NULL,
    [code] NVARCHAR (500) NULL,
    [name] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Datapay/pay_groups/main',
    FILE_FORMAT = [parquet]
    );

