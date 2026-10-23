CREATE EXTERNAL TABLE [RBEAL].[dlFactGroupActivity] (
    [GroupActivityID] INT NULL,
    [ClonedFromID] INT NULL,
    [GroupActivityCreatedDate] DATETIME NULL,
    [GroupActivityCreatedUserId] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactGroupActivity/main',
    FILE_FORMAT = [parquet]
    );

