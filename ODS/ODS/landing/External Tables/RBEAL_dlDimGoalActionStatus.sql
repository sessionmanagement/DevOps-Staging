CREATE EXTERNAL TABLE [landing].[RBEAL_dlDimGoalActionStatus] (
    [GoalActionStatusID] INT NULL,
    [GoalActionStatusCode] NVARCHAR (30) NULL,
    [GoalActionStatusText] NVARCHAR (50) NULL,
    [GoalActionStatusDescription] NVARCHAR (300) NULL,
    [GoalActionStatusIsCompletedStatus] INT NULL,
    [GoalActionStatusIsCancelledStatus] INT NULL,
    [GoalActionStatusSortIndex] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimGoalActionStatus/landing',
    FILE_FORMAT = [parquet]
    );

