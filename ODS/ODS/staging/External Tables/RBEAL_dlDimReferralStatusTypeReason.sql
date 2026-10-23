CREATE EXTERNAL TABLE [staging].[RBEAL_dlDimReferralStatusTypeReason] (
    [ReferralStatusTypeReasonID] INT NULL,
    [ReferralStatusTypeID] INT NULL,
    [ReferralStatusTypeReasonCode] NVARCHAR (50) NULL,
    [ReferralStatusTypeReasonDescription] NVARCHAR (300) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimReferralStatusTypeReason/staging',
    FILE_FORMAT = [parquet]
    );

