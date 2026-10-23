CREATE EXTERNAL TABLE [landing].[RBEAL_dlDimReferralStatusTypeReason] (
    [ReferralStatusTypeReasonID] INT NULL,
    [ReferralStatusTypeID] INT NULL,
    [ReferralStatusTypeReasonCode] NVARCHAR (50) NULL,
    [ReferralStatusTypeReasonDescription] NVARCHAR (300) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimReferralStatusTypeReason/landing',
    FILE_FORMAT = [parquet]
    );

