CREATE EXTERNAL TABLE [staging].[RBEAL_dlFactGoalStatus] (
    [GoalStatusID] INT NULL,
    [GoalID] INT NULL,
    [GoalStatusPercentageComplete] INT NULL,
    [GoalStatusComments] NVARCHAR (MAX) NULL,
    [GoalStatusCreatedUserID] INT NULL,
    [GoalStatusCreatedDate] DATETIME NULL,
    [GoalStatusProgressDate] DATETIME NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactGoalStatus/staging',
    FILE_FORMAT = [parquet]
    );

