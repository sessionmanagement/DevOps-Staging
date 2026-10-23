CREATE EXTERNAL TABLE [landing].[RBMNB_dlFactPersonHealthConditionStatusHistory] (
    [PersonHealthConditionStatusHistoryId] INT NULL,
    [PersonHealthConditionId] INT NULL,
    [PersonHealthConditionStatusHistoryIsCurrent] INT NULL,
    [PersonHealthConditionStatusHistoryCreatedDate] DATETIME NULL,
    [PersonHealthConditionStatusHistoryCreatedUserId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactPersonHealthConditionStatusHistory/landing',
    FILE_FORMAT = [parquet]
    );

