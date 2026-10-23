CREATE EXTERNAL TABLE [staging].[RBMNB_dlDimPhoneNumberType] (
    [PhoneNumberTypeID] INT NULL,
    [PhoneNumberTypeValue] NVARCHAR (200) NULL,
    [PhoneNumberTypeText] NVARCHAR (200) NULL,
    [PhoneNumberTypeParentId] INT NULL,
    [PhoneNumberTypeIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimPhoneNumberType/staging',
    FILE_FORMAT = [parquet]
    );

