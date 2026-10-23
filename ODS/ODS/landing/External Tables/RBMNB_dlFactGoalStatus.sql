CREATE EXTERNAL TABLE [landing].[RBMNB_dlFactGoalStatus] (
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
    LOCATION = N'RBMNB/dlFactGoalStatus/landing',
    FILE_FORMAT = [parquet]
    );

