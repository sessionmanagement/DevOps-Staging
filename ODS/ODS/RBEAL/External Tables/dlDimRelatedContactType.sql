CREATE EXTERNAL TABLE [RBEAL].[dlDimRelatedContactType] (
    [RelatedContactTypeID] INT NULL,
    [RelatedContactTypeValue] NVARCHAR (200) NULL,
    [RelatedContactTypeText] NVARCHAR (200) NULL,
    [RelatedContactTypeParentId] INT NULL,
    [RelatedContactTypeIsActive] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimRelatedContactType/main',
    FILE_FORMAT = [parquet]
    );

