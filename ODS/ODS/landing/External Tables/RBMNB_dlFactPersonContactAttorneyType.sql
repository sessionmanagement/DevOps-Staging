CREATE EXTERNAL TABLE [landing].[RBMNB_dlFactPersonContactAttorneyType] (
    [PersonContactAttorneyTypeId] INT NULL,
    [PersonContactId] INT NULL,
    [AttorneyTypeId] INT NULL,
    [PersonContactAttorneyTypeCreatedDate] DATETIME NULL,
    [PersonContactAttorneyTypeCreatedUserId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactPersonContactAttorneyType/landing',
    FILE_FORMAT = [parquet]
    );

