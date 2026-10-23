CREATE EXTERNAL TABLE [RBEAL].[dlFactGoalStatus] (
    [GoalStatusID] INT NULL,
    [GoalID] INT NULL,
    [GoalStatusPercentageComplete] INT NULL,
    [GoalStatusComments] NVARCHAR (MAX) NULL,
    [GoalStatusCreatedUserID] INT NULL,
    [GoalStatusCreatedDate] DATETIME NULL,
    [GoalStatusProgressDate] DATETIME NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactGoalStatus/main',
    FILE_FORMAT = [parquet]
    );

