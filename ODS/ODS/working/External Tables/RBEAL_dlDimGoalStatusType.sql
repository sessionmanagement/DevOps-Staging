CREATE EXTERNAL TABLE [working].[RBEAL_dlDimGoalStatusType] (
    [GoalStatusTypeID] INT NULL,
    [GoalStatusTypeValue] NVARCHAR (200) NULL,
    [GoalStatusTypeText] NVARCHAR (200) NULL,
    [GoalStatusTypeParentId] INT NULL,
    [GoalStatusTypeIsActive] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimGoalStatusType/working',
    FILE_FORMAT = [parquet]
    );

