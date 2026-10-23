CREATE EXTERNAL TABLE [RBMNB].[dlDimCountry] (
    [CountryID] INT NULL,
    [CountryName] NVARCHAR (100) NULL,
    [CountryCode] NVARCHAR (5) NULL,
    [CountryNationality] NVARCHAR (100) NULL,
    [CountryIsHidden] INT NULL,
    [CountryDiallingCode] NVARCHAR (10) NULL,
    [CountryIsDefault] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimCountry/main',
    FILE_FORMAT = [parquet]
    );

