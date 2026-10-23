CREATE EXTERNAL TABLE [RBEAL].[dlDimPRIMHDReviewWellnessPlanStatus] (
    [PRIMHDReviewWellnessPlanStatusID] INT NULL,
    [PRIMHDReviewWellnessPlanStatusValue] NVARCHAR (200) NULL,
    [PRIMHDReviewWellnessPlanStatusText] NVARCHAR (200) NULL,
    [PRIMHDReviewWellnessPlanStatusParentId] INT NULL,
    [PRIMHDReviewWellnessPlanStatusIsActive] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimPRIMHDReviewWellnessPlanStatus/main',
    FILE_FORMAT = [parquet]
    );

