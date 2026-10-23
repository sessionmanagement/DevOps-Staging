CREATE EXTERNAL TABLE [staging].[RBEAL_dlDimPhoneNumberType] (
    [PhoneNumberTypeID] INT NULL,
    [PhoneNumberTypeValue] NVARCHAR (200) NULL,
    [PhoneNumberTypeText] NVARCHAR (200) NULL,
    [PhoneNumberTypeParentId] INT NULL,
    [PhoneNumberTypeIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimPhoneNumberType/staging',
    FILE_FORMAT = [parquet]
    );

