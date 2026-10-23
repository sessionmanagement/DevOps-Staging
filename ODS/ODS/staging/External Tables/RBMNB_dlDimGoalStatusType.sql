CREATE EXTERNAL TABLE [staging].[RBMNB_dlDimGoalStatusType] (
    [GoalStatusTypeID] INT NULL,
    [GoalStatusTypeValue] NVARCHAR (200) NULL,
    [GoalStatusTypeText] NVARCHAR (200) NULL,
    [GoalStatusTypeParentId] INT NULL,
    [GoalStatusTypeIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimGoalStatusType/staging',
    FILE_FORMAT = [parquet]
    );

