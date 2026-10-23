CREATE EXTERNAL TABLE [working].[RBEAL_dlFactPersonalPlan] (
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
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactPersonalPlan/working',
    FILE_FORMAT = [parquet]
    );

