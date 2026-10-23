CREATE EXTERNAL TABLE [RBMNB].[dlFactPersonContact] (
    [PersonContactID] INT NULL,
    [RelatedContactTypeID] INT NULL,
    [PersonID] INT NULL,
    [PersonContactName] NVARCHAR (200) NULL,
    [PersonContactRelationship] NVARCHAR (200) NULL,
    [PersonContactEmailAddress] NVARCHAR (300) NULL,
    [PersonContactPhone] NVARCHAR (50) NULL,
    [PersonContactPhoneAlternate] NVARCHAR (50) NULL,
    [PersonContactFax] NVARCHAR (50) NULL,
    [PersonContactAddress] NVARCHAR (MAX) NULL,
    [PersonContactComments] NVARCHAR (MAX) NULL,
    [PersonContactIsHiddenFromPerson] INT NULL,
    [PersonContactHiddenReason] NVARCHAR (300) NULL,
    [PersonContactConsentToContact] INT NULL,
    [PersonContactConsentReviewDate] DATETIME NULL,
    [PersonContactInformationDisclosureNotes] NVARCHAR (MAX) NULL,
    [PersonContactIsEmergencyContact] INT NULL,
    [PreferredContactMethodID] INT NULL,
    [PersonContactPreferredContactTime] NVARCHAR (100) NULL,
    [PersonContactCreatedDate] DATETIME NULL,
    [PersonContactCreatedUserID] INT NULL,
    [PersonContactEnduringPowerOfAttorney] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactPersonContact/main',
    FILE_FORMAT = [parquet]
    );

