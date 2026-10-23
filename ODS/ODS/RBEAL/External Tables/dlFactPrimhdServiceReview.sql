CREATE EXTERNAL TABLE [RBEAL].[dlFactPrimhdServiceReview] (
    [PrimhdServiceReviewId] INT NULL,
    [PersonId] INT NULL,
    [PrimhdServiceReviewReviewDate] DATETIME NULL,
    [ReferralId] INT NULL,
    [AccommodationStatusId] INT NULL,
    [EmploymentStatusId] INT NULL,
    [EducationStatusId] INT NULL,
    [WellnessPlanStatusId] INT NULL,
    [PrimhdServiceReviewCreatedDate] DATETIME NULL,
    [PrimhdServiceReviewCreatedUserID] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactPrimhdServiceReview/main',
    FILE_FORMAT = [parquet]
    );

