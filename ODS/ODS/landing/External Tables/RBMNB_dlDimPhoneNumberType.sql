CREATE EXTERNAL TABLE [landing].[RBMNB_dlDimPhoneNumberType] (
    [PhoneNumberTypeID] INT NULL,
    [PhoneNumberTypeValue] NVARCHAR (200) NULL,
    [PhoneNumberTypeText] NVARCHAR (200) NULL,
    [PhoneNumberTypeParentId] INT NULL,
    [PhoneNumberTypeIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimPhoneNumberType/landing',
    FILE_FORMAT = [parquet]
    );

