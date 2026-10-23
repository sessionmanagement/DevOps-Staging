CREATE EXTERNAL TABLE [landing].[RBEAL_dlDimGoalCategory] (
    [GoalCategoryID] INT NULL,
    [GoalCategoryValue] NVARCHAR (200) NULL,
    [GoalCategoryText] NVARCHAR (200) NULL,
    [GoalCategoryParentId] INT NULL,
    [GoalCategoryIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimGoalCategory/landing',
    FILE_FORMAT = [parquet]
    );

