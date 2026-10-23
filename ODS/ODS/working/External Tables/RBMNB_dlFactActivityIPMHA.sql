CREATE EXTERNAL TABLE [working].[RBMNB_dlFactActivityIPMHA] (
    [ActivityIPMHAid] INT NULL,
    [ActivityId] INT NULL,
    [SessionTypeId] INT NULL,
    [JudgementOfChangeId] INT NULL,
    [ActivityIPMHAClientProblemRating] INT NULL,
    [ActivityIPMHAConfidenceInCarryingOutPlans] INT NULL,
    [ActivityIPMHAHowHelpfulWasThisVisit] INT NULL,
    [ExternalReferralId] INT NULL,
    [ActivityIPMHAClientExperienceOfPlan] NVARCHAR (MAX) NULL,
    [ActivityIPMHACreatedUserId] INT NULL,
    [ActivityIPMHACreatedDate] DATETIME2 (7) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactActivityIPMHA/working',
    FILE_FORMAT = [parquet]
    );
GO

