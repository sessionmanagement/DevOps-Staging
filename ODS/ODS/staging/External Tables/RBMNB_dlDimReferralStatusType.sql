CREATE EXTERNAL TABLE [staging].[RBMNB_dlDimReferralStatusType] (
    [ReferralStatusTypeID] INT NULL,
    [ReferralStatusTypeCode] NVARCHAR (10) NULL,
    [ReferralStatusTypeText] NVARCHAR (50) NULL,
    [ReferralStatusTypeDescription] VARCHAR (MAX) NULL,
    [ReferralStatusTypeGroup] NVARCHAR (50) NULL,
    [ReferralStatusTypeStatusOrder] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimReferralStatusType/staging',
    FILE_FORMAT = [parquet]
    );

