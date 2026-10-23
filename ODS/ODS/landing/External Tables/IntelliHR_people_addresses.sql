CREATE EXTERNAL TABLE [landing].[IntelliHR_people_addresses] (
    [people_id] NVARCHAR (36) NULL,
    [addressType] NVARCHAR (10) NULL,
    [fullAddress] NVARCHAR (150) NULL,
    [country] NVARCHAR (50) NULL,
    [postcode] NVARCHAR (10) NULL,
    [state] NVARCHAR (50) NULL,
    [street] NVARCHAR (50) NULL,
    [suburb] NVARCHAR (50) NULL,
    [isPrimary] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/people_addresses/landing',
    FILE_FORMAT = [parquet]
    );

