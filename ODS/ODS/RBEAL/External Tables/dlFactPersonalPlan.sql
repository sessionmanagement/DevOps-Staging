CREATE EXTERNAL TABLE [RBEAL].[dlFactPersonalPlan] (
    [PersonalPlanID] INT NULL,
    [PersonID] INT NULL,
    [PersonalPlanTitle] NVARCHAR (200) NULL,
    [PersonalPlanRawDescription] NVARCHAR (MAX) NULL,
    [PersonalPlanStartDate] SMALLDATETIME NULL,
    [PersonalPlanEndDate] SMALLDATETIME NULL,
    [PersonalPlanReviewCycle] INT NULL,
    [PersonalPlanNextReviewDate] SMALLDATETIME NULL,
    [PersonalPlanCreatedDate] DATETIME NULL,
    [PersonalPlanCreatedUserID] INT NULL,
    [PersonalPlanHtmlDescription] NVARCHAR (MAX) NULL,
    [ReferralID] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactPersonalPlan/main',
    FILE_FORMAT = [parquet]
    );



