CREATE EXTERNAL TABLE [staging].[RBMNB_dlDimGoalCategory] (
    [GoalCategoryID] INT NULL,
    [GoalCategoryValue] NVARCHAR (200) NULL,
    [GoalCategoryText] NVARCHAR (200) NULL,
    [GoalCategoryParentId] INT NULL,
    [GoalCategoryIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimGoalCategory/staging',
    FILE_FORMAT = [parquet]
    );

