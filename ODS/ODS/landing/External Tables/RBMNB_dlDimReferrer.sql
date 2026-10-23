CREATE EXTERNAL TABLE [landing].[RBMNB_dlDimReferrer] (
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
    LOCATION = N'RBMNB/dlDimReferrer/landing',
    FILE_FORMAT = [parquet]
    );

