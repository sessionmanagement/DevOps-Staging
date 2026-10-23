CREATE EXTERNAL TABLE [RBEAL].[dlDimActivityClassification] (
    [ActivityClassificationID] INT NULL,
    [TeamConfigurationID] INT NULL,
    [ActivityClassificationCode] NVARCHAR (20) NULL,
    [ActivityClassificationName] NVARCHAR (50) NULL,
    [ActivityClassificationDescription] NVARCHAR (MAX) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimActivityClassification/main',
    FILE_FORMAT = [parquet]
    );

