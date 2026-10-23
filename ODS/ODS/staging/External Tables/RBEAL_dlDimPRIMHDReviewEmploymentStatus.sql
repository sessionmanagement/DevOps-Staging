CREATE EXTERNAL TABLE [staging].[RBEAL_dlDimPRIMHDReviewEmploymentStatus] (
    [PRIMHDReviewEmploymentStatusID] INT NULL,
    [PRIMHDReviewEmploymentStatusValue] NVARCHAR (200) NULL,
    [PRIMHDReviewEmploymentStatusText] NVARCHAR (200) NULL,
    [PRIMHDReviewEmploymentStatusParentId] INT NULL,
    [PRIMHDReviewEmploymentStatusIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimPRIMHDReviewEmploymentStatus/staging',
    FILE_FORMAT = [parquet]
    );

