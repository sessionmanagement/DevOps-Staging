CREATE EXTERNAL TABLE [working].[RBMNB_dlFactGoalStatus] (
    [GoalStatusID] INT NULL,
    [GoalID] INT NULL,
    [GoalStatusPercentageComplete] INT NULL,
    [GoalStatusComments] NVARCHAR (MAX) NULL,
    [GoalStatusCreatedUserID] INT NULL,
    [GoalStatusCreatedDate] DATETIME NULL,
    [GoalStatusProgressDate] DATETIME NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactGoalStatus/working',
    FILE_FORMAT = [parquet]
    );

