CREATE EXTERNAL TABLE [landing].[Datapay_companies] (
    [company_id] NVARCHAR (50) NULL,
    [name] NVARCHAR (50) NULL,
    [code] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Datapay/companies/landing',
    FILE_FORMAT = [parquet]
    );

