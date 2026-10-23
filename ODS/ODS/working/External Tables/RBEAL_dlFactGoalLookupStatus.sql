CREATE EXTERNAL TABLE [working].[RBEAL_dlFactGoalLookupStatus] (
    [GoalLookupStatusId] INT NULL,
    [GoalId] INT NULL,
    [StatusId] INT NULL,
    [GoalLookupStatusStartDate] DATETIME2 (7) NULL,
    [GoalLookupStatusComment] NVARCHAR (MAX) NULL,
    [GoalLookupStatusCreatedUserId] INT NULL,
    [GoalLookupStatusCreatedDate] DATETIME2 (7) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactGoalLookupStatus/working',
    FILE_FORMAT = [parquet]
    );

