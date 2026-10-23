CREATE EXTERNAL TABLE [working].[RBEAL_dlFactGroupActivity] (
    [GroupActivityID] INT NULL,
    [ClonedFromID] INT NULL,
    [GroupActivityCreatedDate] DATETIME NULL,
    [GroupActivityCreatedUserId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactGroupActivity/working',
    FILE_FORMAT = [parquet]
    );

