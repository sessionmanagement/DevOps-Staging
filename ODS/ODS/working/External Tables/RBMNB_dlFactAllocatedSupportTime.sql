CREATE EXTERNAL TABLE [working].[RBMNB_dlFactAllocatedSupportTime] (
    [AllocatedSupportTimeId] INT NULL,
    [PersonId] INT NULL,
    [TeamId] INT NULL,
    [AllocatedSupportTimeEffectiveDate] DATETIME NULL,
    [AllocatedSupportTimeMinutesPerWeek] INT NULL,
    [AllocatedSupportTimeCreatedDate] DATETIME NULL,
    [AllocatedSupportTimeCreatedUserId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactAllocatedSupportTime/working',
    FILE_FORMAT = [parquet]
    );

