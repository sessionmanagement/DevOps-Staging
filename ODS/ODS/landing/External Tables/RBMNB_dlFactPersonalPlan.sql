CREATE EXTERNAL TABLE [landing].[RBMNB_dlFactPersonalPlan] (
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
    [ReferralID] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactPersonalPlan/landing',
    FILE_FORMAT = [parquet]
    );



