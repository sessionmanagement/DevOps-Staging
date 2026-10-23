CREATE EXTERNAL TABLE [landing].[RBEAL_dlFactPersonLinkRelationship] (
    [PersonLinkRelationshipId] INT NULL,
    [PersonLinkId] INT NULL,
    [RelationshipTypeId] INT NULL,
    [PersonLinkRelationshipStartDate] DATETIME NULL,
    [PersonLinkRelationshipEndDate] DATETIME NULL,
    [PersonLinkRelationshipCreatedDate] DATETIME NULL,
    [PersonLinkRelationshipCreatedUserID] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactPersonLinkRelationship/landing',
    FILE_FORMAT = [parquet]
    );

