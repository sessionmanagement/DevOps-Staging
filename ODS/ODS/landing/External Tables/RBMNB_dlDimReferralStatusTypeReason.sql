CREATE EXTERNAL TABLE [landing].[RBMNB_dlDimReferralStatusTypeReason] (
    [ReferralStatusTypeReasonID] INT NULL,
    [ReferralStatusTypeID] INT NULL,
    [ReferralStatusTypeReasonCode] NVARCHAR (50) NULL,
    [ReferralStatusTypeReasonDescription] NVARCHAR (300) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimReferralStatusTypeReason/landing',
    FILE_FORMAT = [parquet]
    );

