CREATE EXTERNAL TABLE [RBEAL].[dlDimPRIMHDReviewAccommodationStatus] (
    [PRIMHDReviewAccommodationStatusID] INT NULL,
    [PRIMHDReviewAccommodationStatusValue] NVARCHAR (200) NULL,
    [PRIMHDReviewAccommodationStatusText] NVARCHAR (200) NULL,
    [PRIMHDReviewAccommodationStatusParentId] INT NULL,
    [PRIMHDReviewAccommodationStatusIsActive] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimPRIMHDReviewAccommodationStatus/main',
    FILE_FORMAT = [parquet]
    );

