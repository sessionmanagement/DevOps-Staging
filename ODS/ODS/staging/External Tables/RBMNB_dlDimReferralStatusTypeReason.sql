CREATE EXTERNAL TABLE [staging].[RBMNB_dlDimReferralStatusTypeReason] (
    [ReferralStatusTypeReasonID] INT NULL,
    [ReferralStatusTypeID] INT NULL,
    [ReferralStatusTypeReasonCode] NVARCHAR (50) NULL,
    [ReferralStatusTypeReasonDescription] NVARCHAR (300) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimReferralStatusTypeReason/staging',
    FILE_FORMAT = [parquet]
    );

