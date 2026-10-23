CREATE EXTERNAL TABLE [RBEAL].[dlFactPersonHealthConditionStatusHistory] (
    [PersonHealthConditionStatusHistoryId] INT NULL,
    [PersonHealthConditionId] INT NULL,
    [PersonHealthConditionStatusHistoryIsCurrent] INT NULL,
    [PersonHealthConditionStatusHistoryCreatedDate] DATETIME NULL,
    [PersonHealthConditionStatusHistoryCreatedUserId] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactPersonHealthConditionStatusHistory/main',
    FILE_FORMAT = [parquet]
    );

