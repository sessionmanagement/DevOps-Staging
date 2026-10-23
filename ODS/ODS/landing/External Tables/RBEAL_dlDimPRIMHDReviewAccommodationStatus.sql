CREATE EXTERNAL TABLE [landing].[RBEAL_dlDimPRIMHDReviewAccommodationStatus] (
    [PRIMHDReviewAccommodationStatusID] INT NULL,
    [PRIMHDReviewAccommodationStatusValue] NVARCHAR (200) NULL,
    [PRIMHDReviewAccommodationStatusText] NVARCHAR (200) NULL,
    [PRIMHDReviewAccommodationStatusParentId] INT NULL,
    [PRIMHDReviewAccommodationStatusIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimPRIMHDReviewAccommodationStatus/landing',
    FILE_FORMAT = [parquet]
    );

