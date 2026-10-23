CREATE EXTERNAL TABLE [RBMNB].[dlDimReferralStatusType] (
    [ReferralStatusTypeID] INT NULL,
    [ReferralStatusTypeCode] NVARCHAR (10) NULL,
    [ReferralStatusTypeText] NVARCHAR (50) NULL,
    [ReferralStatusTypeDescription] VARCHAR (MAX) NULL,
    [ReferralStatusTypeGroup] NVARCHAR (50) NULL,
    [ReferralStatusTypeStatusOrder] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimReferralStatusType/main',
    FILE_FORMAT = [parquet]
    );

