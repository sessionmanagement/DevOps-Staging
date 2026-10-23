CREATE EXTERNAL TABLE [working].[RBEAL_dlFactPersonContactAttorneyType] (
    [PersonContactAttorneyTypeId] INT NULL,
    [PersonContactId] INT NULL,
    [AttorneyTypeId] INT NULL,
    [PersonContactAttorneyTypeCreatedDate] DATETIME NULL,
    [PersonContactAttorneyTypeCreatedUserId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactPersonContactAttorneyType/working',
    FILE_FORMAT = [parquet]
    );

