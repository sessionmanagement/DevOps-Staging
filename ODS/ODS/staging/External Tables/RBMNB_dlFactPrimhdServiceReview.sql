CREATE EXTERNAL TABLE [staging].[RBMNB_dlFactPrimhdServiceReview] (
    [PrimhdServiceReviewId] INT NULL,
    [PersonId] INT NULL,
    [PrimhdServiceReviewReviewDate] DATETIME NULL,
    [ReferralId] INT NULL,
    [AccommodationStatusId] INT NULL,
    [EmploymentStatusId] INT NULL,
    [EducationStatusId] INT NULL,
    [WellnessPlanStatusId] INT NULL,
    [PrimhdServiceReviewCreatedDate] DATETIME NULL,
    [PrimhdServiceReviewCreatedUserID] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactPrimhdServiceReview/staging',
    FILE_FORMAT = [parquet]
    );

