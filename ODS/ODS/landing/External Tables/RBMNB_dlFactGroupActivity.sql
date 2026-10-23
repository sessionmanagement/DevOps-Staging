CREATE EXTERNAL TABLE [landing].[RBMNB_dlFactGroupActivity] (
    [GroupActivityID] INT NULL,
    [ClonedFromID] INT NULL,
    [GroupActivityCreatedDate] DATETIME NULL,
    [GroupActivityCreatedUserId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactGroupActivity/landing',
    FILE_FORMAT = [parquet]
    );

