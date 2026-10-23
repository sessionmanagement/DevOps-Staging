CREATE EXTERNAL TABLE [RBEAL].[dlFactPersonLegalStatus] (
    [PersonLegalStatusID] INT NULL,
    [PersonID] INT NULL,
    [LegalStatusID] INT NULL,
    [PersonLegalStatusReviewDate] DATETIME NULL,
    [PersonLegalStatusCreatedDate] DATETIME NULL,
    [PersonLegalStatusCreatedUserID] INT NULL,
    [PersonLegalStatusInactiveUserID] INT NULL,
    [PersonLegalStatusInactiveDate] DATETIME NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactPersonLegalStatus/main',
    FILE_FORMAT = [parquet]
    );

