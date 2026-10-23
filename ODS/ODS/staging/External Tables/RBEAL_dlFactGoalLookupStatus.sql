CREATE EXTERNAL TABLE [staging].[RBEAL_dlFactGoalLookupStatus] (
    [GoalLookupStatusId] INT NULL,
    [GoalId] INT NULL,
    [StatusId] INT NULL,
    [GoalLookupStatusStartDate] DATETIME2 (7) NULL,
    [GoalLookupStatusComment] NVARCHAR (MAX) NULL,
    [GoalLookupStatusCreatedUserId] INT NULL,
    [GoalLookupStatusCreatedDate] DATETIME2 (7) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactGoalLookupStatus/staging',
    FILE_FORMAT = [parquet]
    );

