CREATE EXTERNAL TABLE [landing].[RBEAL_dlFactGoalStatus] (
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
    LOCATION = N'RBEAL/dlFactGoalStatus/landing',
    FILE_FORMAT = [parquet]
    );

