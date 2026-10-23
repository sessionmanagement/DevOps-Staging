CREATE EXTERNAL TABLE [landing].[RBMNB_dlFactAddress] (
    [AddressID] INT NULL,
    [AddressName] NVARCHAR (50) NULL,
    [AddressLine1] NVARCHAR (200) NULL,
    [AddressLine2] NVARCHAR (200) NULL,
    [AddressLine3] NVARCHAR (200) NULL,
    [AddressSuburb] NVARCHAR (100) NULL,
    [AddressTownCity] NVARCHAR (50) NULL,
    [CountryID] INT NULL,
    [AddressPostCode] NVARCHAR (50) NULL,
    [AddressIsPostalAddress] INT NULL,
    [AddressMapReference] NVARCHAR (200) NULL,
    [AddressEntityType] NVARCHAR (50) NULL,
    [EntityID] INT NULL,
    [AddressCreatedDate] DATETIME NULL,
    [AddressCreatedUserID] INT NULL,
    [AddressIsPrimaryAddress] INT NULL,
    [ResidenceTypeID] INT NULL,
    [AddressComments] NVARCHAR (MAX) NULL,
    [AccommodationTypeID] INT NULL,
    [StateID] INT NULL,
    [AddressStartDate] DATETIME2 (0) NULL,
    [AddressEndDate] DATETIME2 (0) NULL,
    [AddressAddressSearchUsed] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactAddress/landing',
    FILE_FORMAT = [parquet]
    );

