CREATE EXTERNAL TABLE [RBEAL].[dlDimReferrer] (
    [ReferrerID] INT NULL,
    [ReferrerGroupID] INT NULL,
    [ReferrerCode] NVARCHAR (20) NULL,
    [ReferrerName] NVARCHAR (50) NULL,
    [ReferrerDescription] NVARCHAR (MAX) NULL,
    [ReferrerIsInbound] INT NULL,
    [ReferrerIsOutbound] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimReferrer/main',
    FILE_FORMAT = [parquet]
    );

