CREATE EXTERNAL TABLE [landing].[RBEAL_dlDimRelationshipType] (
    [RelationshipTypeID] INT NULL,
    [RelationshipTypeValue] NVARCHAR (200) NULL,
    [RelationshipTypeText] NVARCHAR (200) NULL,
    [RelationshipTypeParentId] INT NULL,
    [RelationshipTypeIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimRelationshipType/landing',
    FILE_FORMAT = [parquet]
    );

