CREATE EXTERNAL TABLE [RBMNB].[dlFactPersonLinkRelationship] (
    [PersonLinkRelationshipId] INT NULL,
    [PersonLinkId] INT NULL,
    [RelationshipTypeId] INT NULL,
    [PersonLinkRelationshipStartDate] DATETIME NULL,
    [PersonLinkRelationshipEndDate] DATETIME NULL,
    [PersonLinkRelationshipCreatedDate] DATETIME NULL,
    [PersonLinkRelationshipCreatedUserID] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactPersonLinkRelationship/main',
    FILE_FORMAT = [parquet]
    );

