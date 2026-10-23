CREATE EXTERNAL TABLE [RBMNB].[dlDimGoalActionStatus] (
    [GoalActionStatusID] INT NULL,
    [GoalActionStatusCode] NVARCHAR (30) NULL,
    [GoalActionStatusText] NVARCHAR (50) NULL,
    [GoalActionStatusDescription] NVARCHAR (300) NULL,
    [GoalActionStatusIsCompletedStatus] INT NULL,
    [GoalActionStatusIsCancelledStatus] INT NULL,
    [GoalActionStatusSortIndex] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimGoalActionStatus/main',
    FILE_FORMAT = [parquet]
    );

