CREATE EXTERNAL TABLE [staging].[RBEAL_dlDimPRIMHDReviewEducationStatus] (
    [PRIMHDReviewEducationStatusID] INT NULL,
    [PRIMHDReviewEducationStatusValue] NVARCHAR (200) NULL,
    [PRIMHDReviewEducationStatusText] NVARCHAR (200) NULL,
    [PRIMHDReviewEducationStatusParentId] INT NULL,
    [PRIMHDReviewEducationStatusIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimPRIMHDReviewEducationStatus/staging',
    FILE_FORMAT = [parquet]
    );

