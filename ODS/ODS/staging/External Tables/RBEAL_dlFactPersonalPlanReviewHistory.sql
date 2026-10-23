CREATE EXTERNAL TABLE [staging].[RBEAL_dlFactPersonalPlanReviewHistory] (
    [PersonalPlanReviewHistoryID] INT NULL,
    [PersonalPlanID] INT NULL,
    [PersonalPlanReviewHistoryReviewDate] DATETIME NULL,
    [ReviewUserID] INT NULL,
    [PersonalPlanReviewHistoryComments] NVARCHAR (MAX) NULL,
    [PersonalPlanReviewHistoryCreatedDate] DATETIME NULL,
    [PersonalPlanReviewHistoryCreatedUserID] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactPersonalPlanReviewHistory/staging',
    FILE_FORMAT = [parquet]
    );

