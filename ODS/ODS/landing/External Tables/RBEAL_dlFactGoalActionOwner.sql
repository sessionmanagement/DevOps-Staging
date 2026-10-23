CREATE EXTERNAL TABLE [landing].[RBEAL_dlFactGoalActionOwner] (
    [GoalActionOwnerID] INT NULL,
    [GoalActionID] INT NULL,
    [GoalActionOwnerEntityType] NVARCHAR (50) NULL,
    [EntityID] INT NULL,
    [GoalActionOwnerName] NVARCHAR (50) NULL,
    [GoalActionOwnerCreatedDate] DATETIME NULL,
    [GoalActionOwnerCreatedUserID] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactGoalActionOwner/landing',
    FILE_FORMAT = [parquet]
    );

