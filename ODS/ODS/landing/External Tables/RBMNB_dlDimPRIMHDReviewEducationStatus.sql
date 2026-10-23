CREATE EXTERNAL TABLE [landing].[RBMNB_dlDimPRIMHDReviewEducationStatus] (
    [PRIMHDReviewEducationStatusID] INT NULL,
    [PRIMHDReviewEducationStatusValue] NVARCHAR (200) NULL,
    [PRIMHDReviewEducationStatusText] NVARCHAR (200) NULL,
    [PRIMHDReviewEducationStatusParentId] INT NULL,
    [PRIMHDReviewEducationStatusIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimPRIMHDReviewEducationStatus/landing',
    FILE_FORMAT = [parquet]
    );

