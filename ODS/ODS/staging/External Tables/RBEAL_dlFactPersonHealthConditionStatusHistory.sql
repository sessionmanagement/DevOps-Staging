CREATE EXTERNAL TABLE [staging].[RBEAL_dlFactPersonHealthConditionStatusHistory] (
    [PersonHealthConditionStatusHistoryId] INT NULL,
    [PersonHealthConditionId] INT NULL,
    [PersonHealthConditionStatusHistoryIsCurrent] INT NULL,
    [PersonHealthConditionStatusHistoryCreatedDate] DATETIME NULL,
    [PersonHealthConditionStatusHistoryCreatedUserId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactPersonHealthConditionStatusHistory/staging',
    FILE_FORMAT = [parquet]
    );

