CREATE EXTERNAL TABLE [RBEAL].[dlDimLegalStatus] (
    [LegalStatusID] INT NULL,
    [LegalStatusValue] NVARCHAR (200) NULL,
    [LegalStatusText] NVARCHAR (200) NULL,
    [LegalStatusParentId] INT NULL,
    [LegalStatusIsActive] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimLegalStatus/main',
    FILE_FORMAT = [parquet]
    );

