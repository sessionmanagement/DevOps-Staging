CREATE EXTERNAL TABLE [working].[RBEAL_dlFactGoalAction] (
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
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactGoalAction/working',
    FILE_FORMAT = [parquet]
    );

