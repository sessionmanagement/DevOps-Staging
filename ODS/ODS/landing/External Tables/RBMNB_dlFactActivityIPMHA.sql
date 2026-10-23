CREATE EXTERNAL TABLE [landing].[RBMNB_dlFactActivityIPMHA] (
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
    [ActivityIPMHACreatedDate] DATETIME2 (7) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactActivityIPMHA/landing',
    FILE_FORMAT = [parquet]
    );
GO

