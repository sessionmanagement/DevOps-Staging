CREATE EXTERNAL TABLE [staging].[RBEAL_dlFactReferralStatus] (
    [ReferralStatusID] INT NULL,
    [ReferralID] INT NULL,
    [ReferralStatusTypeID] INT NULL,
    [ReferralStatusStartDate] DATETIME NULL,
    [ReferralStatusTypeReasonID] INT NULL,
    [ReferralStatusCreatedUserID] INT NULL,
    [ReferralStatusCreatedDate] DATETIME NULL,
    [ReferralStatusComments] VARCHAR (MAX) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactReferralStatus/staging',
    FILE_FORMAT = [parquet]
    );

