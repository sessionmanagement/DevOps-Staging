CREATE EXTERNAL TABLE [RBEAL].[dlDimGoalStatusType] (
    [GoalStatusTypeID] INT NULL,
    [GoalStatusTypeValue] NVARCHAR (200) NULL,
    [GoalStatusTypeText] NVARCHAR (200) NULL,
    [GoalStatusTypeParentId] INT NULL,
    [GoalStatusTypeIsActive] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimGoalStatusType/main',
    FILE_FORMAT = [parquet]
    );

