CREATE EXTERNAL TABLE [RBMNB].[dlFactReferralStatus] (
    [ReferralStatusID] INT NULL,
    [ReferralID] INT NULL,
    [ReferralStatusTypeID] INT NULL,
    [ReferralStatusStartDate] DATETIME NULL,
    [ReferralStatusTypeReasonID] INT NULL,
    [ReferralStatusCreatedUserID] INT NULL,
    [ReferralStatusCreatedDate] DATETIME NULL,
    [ReferralStatusComments] VARCHAR (MAX) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactReferralStatus/main',
    FILE_FORMAT = [parquet]
    );

