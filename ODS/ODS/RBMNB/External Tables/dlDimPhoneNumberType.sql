CREATE EXTERNAL TABLE [RBMNB].[dlDimPhoneNumberType] (
    [PhoneNumberTypeID] INT NULL,
    [PhoneNumberTypeValue] NVARCHAR (200) NULL,
    [PhoneNumberTypeText] NVARCHAR (200) NULL,
    [PhoneNumberTypeParentId] INT NULL,
    [PhoneNumberTypeIsActive] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimPhoneNumberType/main',
    FILE_FORMAT = [parquet]
    );

