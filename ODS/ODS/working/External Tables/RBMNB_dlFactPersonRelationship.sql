CREATE EXTERNAL TABLE [working].[RBMNB_dlFactPersonRelationship] (
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
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactPersonRelationship/working',
    FILE_FORMAT = [parquet]
    );

