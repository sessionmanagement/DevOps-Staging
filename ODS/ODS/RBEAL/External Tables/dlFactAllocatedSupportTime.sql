CREATE EXTERNAL TABLE [RBEAL].[dlFactAllocatedSupportTime] (
    [AllocatedSupportTimeId] INT NULL,
    [PersonId] INT NULL,
    [TeamId] INT NULL,
    [AllocatedSupportTimeEffectiveDate] DATETIME NULL,
    [AllocatedSupportTimeMinutesPerWeek] INT NULL,
    [AllocatedSupportTimeCreatedDate] DATETIME NULL,
    [AllocatedSupportTimeCreatedUserId] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactAllocatedSupportTime/main',
    FILE_FORMAT = [parquet]
    );

