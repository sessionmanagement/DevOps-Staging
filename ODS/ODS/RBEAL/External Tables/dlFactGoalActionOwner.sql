CREATE EXTERNAL TABLE [RBEAL].[dlFactGoalActionOwner] (
    [GoalActionOwnerID] INT NULL,
    [GoalActionID] INT NULL,
    [GoalActionOwnerEntityType] NVARCHAR (50) NULL,
    [EntityID] INT NULL,
    [GoalActionOwnerName] NVARCHAR (50) NULL,
    [GoalActionOwnerCreatedDate] DATETIME NULL,
    [GoalActionOwnerCreatedUserID] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactGoalActionOwner/main',
    FILE_FORMAT = [parquet]
    );

