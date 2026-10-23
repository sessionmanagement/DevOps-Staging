CREATE EXTERNAL TABLE [staging].[RBEAL_dlFactAllocatedSupportTime] (
    [AllocatedSupportTimeId] INT NULL,
    [PersonId] INT NULL,
    [TeamId] INT NULL,
    [AllocatedSupportTimeEffectiveDate] DATETIME NULL,
    [AllocatedSupportTimeMinutesPerWeek] INT NULL,
    [AllocatedSupportTimeCreatedDate] DATETIME NULL,
    [AllocatedSupportTimeCreatedUserId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactAllocatedSupportTime/staging',
    FILE_FORMAT = [parquet]
    );

