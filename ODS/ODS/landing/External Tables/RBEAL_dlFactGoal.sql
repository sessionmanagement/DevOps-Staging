CREATE EXTERNAL TABLE [landing].[RBEAL_dlFactGoal] (
    [GoalID] INT NULL,
    [GoalTitle] NVARCHAR (200) NULL,
    [GoalRawDescription] NVARCHAR (MAX) NULL,
    [GoalHTMLDescription] NVARCHAR (MAX) NULL,
    [GoalStartDate] DATETIME NULL,
    [GoalDueDate] DATETIME NULL,
    [OldGoalID] INT NULL,
    [PersonID] INT NULL,
    [GoalRawComments] NVARCHAR (MAX) NULL,
    [GoalHTMLComments] NVARCHAR (MAX) NULL,
    [InactiveGoalReasonID] INT NULL,
    [GoalCreatedDate] DATETIME NULL,
    [GoalCreatedUserID] INT NULL,
    [ReferralID] INT NULL,
    [PersonalPlanID] INT NULL,
    [GoalCloseCompletedDate] DATETIME NULL,
    [GoalCloseNotCompletedDate] DATETIME NULL,
    [GoalCloseComments] NVARCHAR (MAX) NULL,
    [CategoryID] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactGoal/landing',
    FILE_FORMAT = [parquet]
    );



