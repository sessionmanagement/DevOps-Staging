CREATE EXTERNAL TABLE [working].[RBMNB_dlFactPhone] (
    [PhoneID] INT NULL,
    [PhoneName] VARCHAR (50) NULL,
    [PhonePhoneNumber] VARCHAR (60) NULL,
    [PhoneNumberTypeID] INT NULL,
    [PhoneEntityType] VARCHAR (50) NULL,
    [EntityID] INT NULL,
    [PhoneCreatedDate] DATETIME NULL,
    [PhoneCreatedUserID] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactPhone/working',
    FILE_FORMAT = [parquet]
    );

