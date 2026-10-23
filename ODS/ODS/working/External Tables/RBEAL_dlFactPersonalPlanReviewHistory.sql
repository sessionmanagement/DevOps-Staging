CREATE EXTERNAL TABLE [working].[RBEAL_dlFactPersonalPlanReviewHistory] (
    [PersonalPlanReviewHistoryID] INT NULL,
    [PersonalPlanID] INT NULL,
    [PersonalPlanReviewHistoryReviewDate] DATETIME NULL,
    [ReviewUserID] INT NULL,
    [PersonalPlanReviewHistoryComments] NVARCHAR (MAX) NULL,
    [PersonalPlanReviewHistoryCreatedDate] DATETIME NULL,
    [PersonalPlanReviewHistoryCreatedUserID] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactPersonalPlanReviewHistory/working',
    FILE_FORMAT = [parquet]
    );

