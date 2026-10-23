CREATE EXTERNAL TABLE [RBEAL].[dlDimReferralStatusTypeReason] (
    [ReferralStatusTypeReasonID] INT NULL,
    [ReferralStatusTypeID] INT NULL,
    [ReferralStatusTypeReasonCode] NVARCHAR (50) NULL,
    [ReferralStatusTypeReasonDescription] NVARCHAR (300) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimReferralStatusTypeReason/main',
    FILE_FORMAT = [parquet]
    );

