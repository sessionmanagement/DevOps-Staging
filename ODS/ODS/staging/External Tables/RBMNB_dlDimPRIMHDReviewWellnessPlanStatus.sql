CREATE EXTERNAL TABLE [staging].[RBMNB_dlDimPRIMHDReviewWellnessPlanStatus] (
    [PRIMHDReviewWellnessPlanStatusID] INT NULL,
    [PRIMHDReviewWellnessPlanStatusValue] NVARCHAR (200) NULL,
    [PRIMHDReviewWellnessPlanStatusText] NVARCHAR (200) NULL,
    [PRIMHDReviewWellnessPlanStatusParentId] INT NULL,
    [PRIMHDReviewWellnessPlanStatusIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimPRIMHDReviewWellnessPlanStatus/staging',
    FILE_FORMAT = [parquet]
    );

