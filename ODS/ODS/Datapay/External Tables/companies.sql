CREATE EXTERNAL TABLE [Datapay].[companies] (
    [company_id] NVARCHAR (50) NULL,
    [name] NVARCHAR (50) NULL,
    [code] INT NULL,
    [ODSIsCurrent] INT,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1),
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'Datapay/companies/main',
    FILE_FORMAT = [parquet]
    );

