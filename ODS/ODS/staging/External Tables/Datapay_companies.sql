CREATE EXTERNAL TABLE [staging].[Datapay_companies] (
    [company_id] NVARCHAR (50) NULL,
    [name] NVARCHAR (50) NULL,
    [code] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Datapay/companies/staging',
    FILE_FORMAT = [parquet]
    );

