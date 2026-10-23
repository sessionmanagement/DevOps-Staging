CREATE EXTERNAL TABLE [landing].[RBMNB_dlFactPersonalPlanReviewHistory] (
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
    LOCATION = N'RBMNB/dlFactPersonalPlanReviewHistory/landing',
    FILE_FORMAT = [parquet]
    );

