CREATE EXTERNAL TABLE [staging].[RBMNB_dlFactEmploymentPlan] (
    [EmploymentPlanID] INT NULL,
    [EmploymentPlanTemplateID] INT NULL,
    [EmploymentPlanStartDate] DATETIME NULL,
    [EmploymentPlanCloseDate] DATETIME NULL,
    [CurrentPhaseID] INT NULL,
    [PrimaryCaseWorkerID] INT NULL,
    [ReferralID] INT NULL,
    [EmploymentPlanPlanningAndPrepExpectedDuration] INT NULL,
    [EmploymentPlanPlanningAndPrepExpectedActivityHours] INT NULL,
    [EmploymentPlanPlanningAndPrepRequireCompletionOfMandatoryTasks] INT NULL,
    [EmploymentPlanJobSearchExpectedDuration] INT NULL,
    [EmploymentPlanJobSearchExpectedActivityHours] INT NULL,
    [EmploymentPlanJobSearchRequireCompletionOfMandatoryTasks] INT NULL,
    [EmploymentPlanJobSearchStartDate] DATETIME NULL,
    [EmploymentPlanPlacementSupportExpectedDuration] INT NULL,
    [EmploymentPlanPlacementSupportExpectedActivityHours] INT NULL,
    [EmploymentPlanPlacementSupportStartDate] DATETIME NULL,
    [EmploymentPlanCreatedDate] DATETIME NULL,
    [EmploymentPlanCreatedUserID] INT NULL,
    [PersonID] INT NULL,
    [EmploymentPlanClosedComments] NVARCHAR (MAX) NULL,
    [EmploymentPlanUDF1] NVARCHAR (MAX) NULL,
    [EmploymentPlanUDF2] NVARCHAR (MAX) NULL,
    [EmploymentPlanUDF3] NVARCHAR (MAX) NULL,
    [EmploymentPlanUDF4] NVARCHAR (MAX) NULL,
    [EmploymentPlanUDF5] NVARCHAR (MAX) NULL,
    [ClosedReasonID] INT NULL,
    [EmploymentPlanIsSupportPlan] INT NULL,
    [EmploymentPlanTitle] NVARCHAR (200) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactEmploymentPlan/staging',
    FILE_FORMAT = [parquet]
    );

