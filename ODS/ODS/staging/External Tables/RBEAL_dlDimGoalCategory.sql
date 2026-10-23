CREATE EXTERNAL TABLE [staging].[RBEAL_dlDimGoalCategory] (
    [GoalCategoryID] INT NULL,
    [GoalCategoryValue] NVARCHAR (200) NULL,
    [GoalCategoryText] NVARCHAR (200) NULL,
    [GoalCategoryParentId] INT NULL,
    [GoalCategoryIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimGoalCategory/staging',
    FILE_FORMAT = [parquet]
    );

