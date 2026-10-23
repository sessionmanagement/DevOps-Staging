CREATE EXTERNAL TABLE [landing].[RBMNB_dlDimPRIMHDReviewEmploymentStatus] (
    [PRIMHDReviewEmploymentStatusID] INT NULL,
    [PRIMHDReviewEmploymentStatusValue] NVARCHAR (200) NULL,
    [PRIMHDReviewEmploymentStatusText] NVARCHAR (200) NULL,
    [PRIMHDReviewEmploymentStatusParentId] INT NULL,
    [PRIMHDReviewEmploymentStatusIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimPRIMHDReviewEmploymentStatus/landing',
    FILE_FORMAT = [parquet]
    );

