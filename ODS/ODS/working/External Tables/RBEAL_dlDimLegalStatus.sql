CREATE EXTERNAL TABLE [working].[RBEAL_dlDimLegalStatus] (
    [LegalStatusID] INT NULL,
    [LegalStatusValue] NVARCHAR (200) NULL,
    [LegalStatusText] NVARCHAR (200) NULL,
    [LegalStatusParentId] INT NULL,
    [LegalStatusIsActive] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimLegalStatus/working',
    FILE_FORMAT = [parquet]
    );

