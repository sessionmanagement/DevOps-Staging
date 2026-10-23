CREATE EXTERNAL TABLE [staging].[RBEAL_dlFactPersonContactAttorneyType] (
    [PersonContactAttorneyTypeId] INT NULL,
    [PersonContactId] INT NULL,
    [AttorneyTypeId] INT NULL,
    [PersonContactAttorneyTypeCreatedDate] DATETIME NULL,
    [PersonContactAttorneyTypeCreatedUserId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactPersonContactAttorneyType/staging',
    FILE_FORMAT = [parquet]
    );

