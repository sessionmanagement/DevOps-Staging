CREATE EXTERNAL TABLE [landing].[RBEAL_dlFactGroupActivity] (
    [GroupActivityID] INT NULL,
    [ClonedFromID] INT NULL,
    [GroupActivityCreatedDate] DATETIME NULL,
    [GroupActivityCreatedUserId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactGroupActivity/landing',
    FILE_FORMAT = [parquet]
    );

