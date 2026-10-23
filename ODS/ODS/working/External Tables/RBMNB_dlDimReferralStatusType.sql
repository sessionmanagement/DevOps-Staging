CREATE EXTERNAL TABLE [working].[RBMNB_dlDimReferralStatusType] (
    [ReferralStatusTypeID] INT NULL,
    [ReferralStatusTypeCode] NVARCHAR (10) NULL,
    [ReferralStatusTypeText] NVARCHAR (50) NULL,
    [ReferralStatusTypeDescription] VARCHAR (MAX) NULL,
    [ReferralStatusTypeGroup] NVARCHAR (50) NULL,
    [ReferralStatusTypeStatusOrder] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimReferralStatusType/working',
    FILE_FORMAT = [parquet]
    );

