CREATE EXTERNAL TABLE [staging].[RBEAL_dlDimGoalStatusType] (
    [GoalStatusTypeID] INT NULL,
    [GoalStatusTypeValue] NVARCHAR (200) NULL,
    [GoalStatusTypeText] NVARCHAR (200) NULL,
    [GoalStatusTypeParentId] INT NULL,
    [GoalStatusTypeIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimGoalStatusType/staging',
    FILE_FORMAT = [parquet]
    );

