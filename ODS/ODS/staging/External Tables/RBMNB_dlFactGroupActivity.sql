CREATE EXTERNAL TABLE [staging].[RBMNB_dlFactGroupActivity] (
    [GroupActivityID] INT NULL,
    [ClonedFromID] INT NULL,
    [GroupActivityCreatedDate] DATETIME NULL,
    [GroupActivityCreatedUserId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactGroupActivity/staging',
    FILE_FORMAT = [parquet]
    );

