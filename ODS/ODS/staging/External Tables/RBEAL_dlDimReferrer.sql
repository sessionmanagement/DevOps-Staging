CREATE EXTERNAL TABLE [staging].[RBEAL_dlDimReferrer] (
    [ReferrerID] INT NULL,
    [ReferrerGroupID] INT NULL,
    [ReferrerCode] NVARCHAR (20) NULL,
    [ReferrerName] NVARCHAR (50) NULL,
    [ReferrerDescription] NVARCHAR (MAX) NULL,
    [ReferrerIsInbound] INT NULL,
    [ReferrerIsOutbound] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimReferrer/staging',
    FILE_FORMAT = [parquet]
    );

