CREATE EXTERNAL TABLE [working].[RBMNB_dlDimCountry] (
    [CountryID] INT NULL,
    [CountryName] NVARCHAR (100) NULL,
    [CountryCode] NVARCHAR (5) NULL,
    [CountryNationality] NVARCHAR (100) NULL,
    [CountryIsHidden] INT NULL,
    [CountryDiallingCode] NVARCHAR (10) NULL,
    [CountryIsDefault] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimCountry/working',
    FILE_FORMAT = [parquet]
    );

