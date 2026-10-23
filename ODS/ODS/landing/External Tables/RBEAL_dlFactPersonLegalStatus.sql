CREATE EXTERNAL TABLE [landing].[RBEAL_dlFactPersonLegalStatus] (
    [PersonLegalStatusID] INT NULL,
    [PersonID] INT NULL,
    [LegalStatusID] INT NULL,
    [PersonLegalStatusReviewDate] DATETIME NULL,
    [PersonLegalStatusCreatedDate] DATETIME NULL,
    [PersonLegalStatusCreatedUserID] INT NULL,
    [PersonLegalStatusInactiveUserID] INT NULL,
    [PersonLegalStatusInactiveDate] DATETIME NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactPersonLegalStatus/landing',
    FILE_FORMAT = [parquet]
    );

