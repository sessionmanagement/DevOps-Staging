CREATE EXTERNAL TABLE [working].[Datapay_companies] (
    [company_id] NVARCHAR (50) NULL,
    [name] NVARCHAR (50) NULL,
    [code] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Datapay/companies/working',
    FILE_FORMAT = [parquet]
    );

