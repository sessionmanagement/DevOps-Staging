CREATE EXTERNAL TABLE [staging].[RBEAL_otFactOutcomeToolResponse] (
    [OutcomeToolResponseID] INT NULL,
    [OutcomeToolTemplateID] INT NULL,
    [PersonID] INT NULL,
    [ReferralID] INT NULL,
    [ResponseSecuredAgainstReferral] INT NULL,
    [ResponseCreatedUserID] INT NULL,
    [ResponseCreatedDate] DATETIME NULL,
    [ActivityId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/otFactOutcomeToolResponse/staging',
    FILE_FORMAT = [parquet]
    );

