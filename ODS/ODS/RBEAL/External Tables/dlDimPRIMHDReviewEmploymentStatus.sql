CREATE EXTERNAL TABLE [RBEAL].[dlDimPRIMHDReviewEmploymentStatus] (
    [PRIMHDReviewEmploymentStatusID] INT NULL,
    [PRIMHDReviewEmploymentStatusValue] NVARCHAR (200) NULL,
    [PRIMHDReviewEmploymentStatusText] NVARCHAR (200) NULL,
    [PRIMHDReviewEmploymentStatusParentId] INT NULL,
    [PRIMHDReviewEmploymentStatusIsActive] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimPRIMHDReviewEmploymentStatus/main',
    FILE_FORMAT = [parquet]
    );

