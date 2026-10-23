CREATE EXTERNAL TABLE [RBMNB].[dlDimAccountActivityClassification] (
    [AccountActivityClassificationID] INT NULL,
    [AccountActivityClassificationValue] NVARCHAR (200) NULL,
    [AccountActivityClassificationText] NVARCHAR (200) NULL,
    [AccountActivityClassificationParentId] INT NULL,
    [AccountActivityClassificationIsActive] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimAccountActivityClassification/main',
    FILE_FORMAT = [parquet]
    );

