CREATE EXTERNAL TABLE [landing].[RBMNB_dlFactAllocatedSupportTime] (
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
    LOCATION = N'RBMNB/dlFactAllocatedSupportTime/landing',
    FILE_FORMAT = [parquet]
    );

