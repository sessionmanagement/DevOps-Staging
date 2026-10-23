CREATE EXTERNAL TABLE [RBMNB].[dlFactReferralServiceLevel] (
    [ReferralServiceLevelId] INT NULL,
    [ReferralServiceLevelDefinitionId] INT NULL,
    [ReferralId] INT NULL,
    [LookupId] INT NULL,
    [ReferralServiceLevelEffectiveFrom] DATETIME NULL,
    [ReferralServiceLevelCreatedDate] DATETIME NULL,
    [ReferralServiceLevelCreatedUserId] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactReferralServiceLevel/main',
    FILE_FORMAT = [parquet]
    );

