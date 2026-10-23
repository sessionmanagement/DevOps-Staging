CREATE EXTERNAL TABLE [staging].[RBMNB_dlDimPRIMHDReviewAccommodationStatus] (
    [PRIMHDReviewAccommodationStatusID] INT NULL,
    [PRIMHDReviewAccommodationStatusValue] NVARCHAR (200) NULL,
    [PRIMHDReviewAccommodationStatusText] NVARCHAR (200) NULL,
    [PRIMHDReviewAccommodationStatusParentId] INT NULL,
    [PRIMHDReviewAccommodationStatusIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimPRIMHDReviewAccommodationStatus/staging',
    FILE_FORMAT = [parquet]
    );

