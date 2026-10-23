CREATE EXTERNAL TABLE [staging].[RBMNB_dlFactPersonHealthConditionStatusHistory] (
    [PersonHealthConditionStatusHistoryId] INT NULL,
    [PersonHealthConditionId] INT NULL,
    [PersonHealthConditionStatusHistoryIsCurrent] INT NULL,
    [PersonHealthConditionStatusHistoryCreatedDate] DATETIME NULL,
    [PersonHealthConditionStatusHistoryCreatedUserId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactPersonHealthConditionStatusHistory/staging',
    FILE_FORMAT = [parquet]
    );

