CREATE EXTERNAL TABLE [staging].[RBMNB_dlDimRelationshipType] (
    [RelationshipTypeID] INT NULL,
    [RelationshipTypeValue] NVARCHAR (200) NULL,
    [RelationshipTypeText] NVARCHAR (200) NULL,
    [RelationshipTypeParentId] INT NULL,
    [RelationshipTypeIsActive] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimRelationshipType/staging',
    FILE_FORMAT = [parquet]
    );

