CREATE EXTERNAL TABLE [staging].[RBMNB_dlFactGoalActionOwner] (
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
    LOCATION = N'RBMNB/dlFactGoalActionOwner/staging',
    FILE_FORMAT = [parquet]
    );

