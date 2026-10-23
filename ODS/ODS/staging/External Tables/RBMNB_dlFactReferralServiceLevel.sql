CREATE EXTERNAL TABLE [staging].[RBMNB_dlFactReferralServiceLevel] (
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
    LOCATION = N'RBMNB/dlFactReferralServiceLevel/staging',
    FILE_FORMAT = [parquet]
    );

