CREATE EXTERNAL TABLE [landing].[RBMNB_dlDimGoalCategory] (
    [GoalCategoryID] INT NULL,
    [GoalCategoryValue] NVARCHAR (200) NULL,
    [GoalCategoryText] NVARCHAR (200) NULL,
    [GoalCategoryParentId] INT NULL,
    [GoalCategoryIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimGoalCategory/landing',
    FILE_FORMAT = [parquet]
    );

