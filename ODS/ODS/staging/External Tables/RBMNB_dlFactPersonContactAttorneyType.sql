CREATE EXTERNAL TABLE [staging].[RBMNB_dlFactPersonContactAttorneyType] (
    [PersonContactAttorneyTypeId] INT NULL,
    [PersonContactId] INT NULL,
    [AttorneyTypeId] INT NULL,
    [PersonContactAttorneyTypeCreatedDate] DATETIME NULL,
    [PersonContactAttorneyTypeCreatedUserId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactPersonContactAttorneyType/staging',
    FILE_FORMAT = [parquet]
    );

