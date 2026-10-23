CREATE EXTERNAL TABLE [landing].[RBMNB_dlDimPRIMHDReviewWellnessPlanStatus] (
    [PRIMHDReviewWellnessPlanStatusID] INT NULL,
    [PRIMHDReviewWellnessPlanStatusValue] NVARCHAR (200) NULL,
    [PRIMHDReviewWellnessPlanStatusText] NVARCHAR (200) NULL,
    [PRIMHDReviewWellnessPlanStatusParentId] INT NULL,
    [PRIMHDReviewWellnessPlanStatusIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimPRIMHDReviewWellnessPlanStatus/landing',
    FILE_FORMAT = [parquet]
    );

