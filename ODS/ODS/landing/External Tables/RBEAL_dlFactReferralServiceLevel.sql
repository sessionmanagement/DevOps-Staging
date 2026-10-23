CREATE EXTERNAL TABLE [landing].[RBEAL_dlFactReferralServiceLevel] (
    [ReferralServiceLevelId] INT NULL,
    [ReferralServiceLevelDefinitionId] INT NULL,
    [ReferralId] INT NULL,
    [LookupId] INT NULL,
    [ReferralServiceLevelEffectiveFrom] DATETIME NULL,
    [ReferralServiceLevelCreatedDate] DATETIME NULL,
    [ReferralServiceLevelCreatedUserId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactReferralServiceLevel/landing',
    FILE_FORMAT = [parquet]
    );

