CREATE EXTERNAL TABLE [staging].[RBMNB_dlFactGoalLookupStatus] (
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
    LOCATION = N'RBMNB/dlFactGoalLookupStatus/staging',
    FILE_FORMAT = [parquet]
    );

