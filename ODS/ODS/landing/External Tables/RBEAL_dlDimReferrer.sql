CREATE EXTERNAL TABLE [landing].[RBEAL_dlDimReferrer] (
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
    LOCATION = N'RBEAL/dlDimReferrer/landing',
    FILE_FORMAT = [parquet]
    );

