CREATE EXTERNAL TABLE [RBEAL].[dlDimPersonInteractionType] (
    [PersonInteractionTypeId] INT NULL,
    [PersonInteractionTypeCode] NVARCHAR (MAX) NULL,
    [PersonInteractionTypeName] NVARCHAR (MAX) NULL,
    [PersonInteractionTypeParentId] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimPersonInteractionType/main',
    FILE_FORMAT = [parquet]
    );
