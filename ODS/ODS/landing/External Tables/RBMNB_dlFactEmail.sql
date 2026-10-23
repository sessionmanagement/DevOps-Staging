CREATE EXTERNAL TABLE [landing].[RBMNB_dlFactEmail] (
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
    LOCATION = N'RBMNB/dlFactEmail/landing',
    FILE_FORMAT = [parquet]
    );

