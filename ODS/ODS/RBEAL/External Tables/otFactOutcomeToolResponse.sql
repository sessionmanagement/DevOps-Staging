CREATE EXTERNAL TABLE [RBEAL].[otFactOutcomeToolResponse] (
    [OutcomeToolResponseID] INT NULL,
    [OutcomeToolTemplateID] INT NULL,
    [PersonID] INT NULL,
    [ReferralID] INT NULL,
    [ResponseSecuredAgainstReferral] INT NULL,
    [ResponseCreatedUserID] INT NULL,
    [ResponseCreatedDate] DATETIME NULL,
    [ActivityId] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/otFactOutcomeToolResponse/main',
    FILE_FORMAT = [parquet]
    );

