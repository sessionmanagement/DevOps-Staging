CREATE EXTERNAL TABLE [RBMNB].[dlFactGoalAction] (
    [GoalActionID] INT NULL,
    [GoalID] INT NULL,
    [GoalActionDescription] NVARCHAR (MAX) NULL,
    [GoalActionDueDate] DATETIME NULL,
    [GoalActionCompletedDate] DATETIME NULL,
    [CompletedUserID] INT NULL,
    [GoalActionStatusID] INT NULL,
    [GoalActionComments] NVARCHAR (MAX) NULL,
    [GoalActionCreatedUserID] INT NULL,
    [GoalActionCreatedDate] DATETIME NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactGoalAction/main',
    FILE_FORMAT = [parquet]
    );

