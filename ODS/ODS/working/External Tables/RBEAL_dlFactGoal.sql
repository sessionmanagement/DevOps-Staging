CREATE EXTERNAL TABLE [working].[RBEAL_dlFactGoal] (
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
    [CategoryID] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactGoal/working',
    FILE_FORMAT = [parquet]
    );



