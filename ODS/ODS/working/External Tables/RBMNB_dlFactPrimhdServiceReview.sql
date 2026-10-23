CREATE EXTERNAL TABLE [working].[RBMNB_dlFactPrimhdServiceReview] (
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
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactPrimhdServiceReview/working',
    FILE_FORMAT = [parquet]
    );

