CREATE EXTERNAL TABLE [RBMNB].[dlDimRelationshipType] (
    [RelationshipTypeID] INT NULL,
    [RelationshipTypeValue] NVARCHAR (200) NULL,
    [RelationshipTypeText] NVARCHAR (200) NULL,
    [RelationshipTypeParentId] INT NULL,
    [RelationshipTypeIsActive] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimRelationshipType/main',
    FILE_FORMAT = [parquet]
    );

