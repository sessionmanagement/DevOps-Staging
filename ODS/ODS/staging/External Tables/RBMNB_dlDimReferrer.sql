CREATE EXTERNAL TABLE [staging].[RBMNB_dlDimReferrer] (
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
    LOCATION = N'RBMNB/dlDimReferrer/staging',
    FILE_FORMAT = [parquet]
    );

