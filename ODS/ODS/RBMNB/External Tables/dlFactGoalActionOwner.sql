CREATE EXTERNAL TABLE [RBMNB].[dlFactGoalActionOwner] (
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
    LOCATION = N'RBMNB/dlFactGoalActionOwner/main',
    FILE_FORMAT = [parquet]
    );

