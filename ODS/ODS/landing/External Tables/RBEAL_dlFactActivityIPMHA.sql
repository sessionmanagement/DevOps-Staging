CREATE EXTERNAL TABLE [landing].[RBEAL_dlFactActivityIPMHA] (
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
    [NextEncounterBookedId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactActivityIPMHA/landing',
    FILE_FORMAT = [parquet]
    );
GO

