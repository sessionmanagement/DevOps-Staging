CREATE EXTERNAL TABLE [landing].[RBMNB_dlDimCountry] (
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
    LOCATION = N'RBMNB/dlDimCountry/landing',
    FILE_FORMAT = [parquet]
    );

