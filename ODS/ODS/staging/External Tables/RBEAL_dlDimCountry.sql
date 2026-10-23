CREATE EXTERNAL TABLE [staging].[RBEAL_dlDimCountry] (
    [CountryID] INT NULL,
    [CountryName] NVARCHAR (100) NULL,
    [CountryCode] NVARCHAR (5) NULL,
    [CountryNationality] NVARCHAR (100) NULL,
    [CountryIsHidden] INT NULL,
    [CountryDiallingCode] NVARCHAR (10) NULL,
    [CountryIsDefault] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimCountry/staging',
    FILE_FORMAT = [parquet]
    );

