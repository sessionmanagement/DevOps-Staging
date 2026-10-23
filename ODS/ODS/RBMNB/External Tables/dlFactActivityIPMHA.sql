CREATE EXTERNAL TABLE [RBMNB].[dlFactActivityIPMHA] (
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
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactActivityIPMHA/main',
    FILE_FORMAT = [parquet]
    );
GO

