CREATE EXTERNAL TABLE [RBEAL].[dlFactPhone] (
    [PhoneID] INT NULL,
    [PhoneName] VARCHAR (50) NULL,
    [PhonePhoneNumber] VARCHAR (60) NULL,
    [PhoneNumberTypeID] INT NULL,
    [PhoneEntityType] VARCHAR (50) NULL,
    [EntityID] INT NULL,
    [PhoneCreatedDate] DATETIME NULL,
    [PhoneCreatedUserID] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactPhone/main',
    FILE_FORMAT = [parquet]
    );

