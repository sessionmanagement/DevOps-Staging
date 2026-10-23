CREATE EXTERNAL TABLE [RBMNB].[dlDimGoalCategory] (
    [GoalCategoryID] INT NULL,
    [GoalCategoryValue] NVARCHAR (200) NULL,
    [GoalCategoryText] NVARCHAR (200) NULL,
    [GoalCategoryParentId] INT NULL,
    [GoalCategoryIsActive] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimGoalCategory/main',
    FILE_FORMAT = [parquet]
    );

