CREATE EXTERNAL TABLE [RBMNB].[dlFactPersonRelationship] (
    [PersonRelationshipID] INT NULL,
    [PersonID] INT NULL,
    [UserID] INT NULL,
    [RelationshipTypeID] INT NULL,
    [PersonRelationshipStartDate] DATETIME NULL,
    [PersonRelationshipEndDate] DATETIME NULL,
    [PersonRelationshipDetail] VARCHAR (300) NULL,
    [PersonRelationshipCreatedUserID] INT NULL,
    [PersonRelationshipCreatedDate] DATETIME NULL,
    [ReferralId] INT NULL,
    [PersonRelationshipIsPrimaryCaseworker] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactPersonRelationship/main',
    FILE_FORMAT = [parquet]
    );

