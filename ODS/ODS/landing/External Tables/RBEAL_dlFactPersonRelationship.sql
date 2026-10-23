CREATE EXTERNAL TABLE [landing].[RBEAL_dlFactPersonRelationship] (
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
    [PersonRelationshipIsPrimaryCaseworker] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactPersonRelationship/landing',
    FILE_FORMAT = [parquet]
    );

