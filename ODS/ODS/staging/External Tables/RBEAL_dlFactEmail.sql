CREATE EXTERNAL TABLE [staging].[RBEAL_dlFactEmail] (
    [EmailID] INT NULL,
    [EmailEmail] VARCHAR (300) NULL,
    [EmailConsentToEmail] INT NULL,
    [EmailIsPrimary] INT NULL,
    [EmailEntityType] VARCHAR (50) NULL,
    [EntityID] INT NULL,
    [EmailCreatedDate] DATETIME NULL,
    [EmailCreatedUserID] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactEmail/staging',
    FILE_FORMAT = [parquet]
    );

