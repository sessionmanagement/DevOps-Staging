CREATE EXTERNAL TABLE [RBMNB].[dlDimPRIMHDReviewEducationStatus] (
    [PRIMHDReviewEducationStatusID] INT NULL,
    [PRIMHDReviewEducationStatusValue] NVARCHAR (200) NULL,
    [PRIMHDReviewEducationStatusText] NVARCHAR (200) NULL,
    [PRIMHDReviewEducationStatusParentId] INT NULL,
    [PRIMHDReviewEducationStatusIsActive] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimPRIMHDReviewEducationStatus/main',
    FILE_FORMAT = [parquet]
    );

