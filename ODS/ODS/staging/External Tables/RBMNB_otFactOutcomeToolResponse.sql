CREATE EXTERNAL TABLE [staging].[RBMNB_otFactOutcomeToolResponse] (
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
    LOCATION = N'RBMNB/otFactOutcomeToolResponse/staging',
    FILE_FORMAT = [parquet]
    );

