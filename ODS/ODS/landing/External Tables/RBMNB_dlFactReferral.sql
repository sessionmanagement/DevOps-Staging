CREATE EXTERNAL TABLE [landing].[RBMNB_dlFactReferral] (
    [ReferralID] INT NULL,
    [PersonID] INT NULL,
    [ReferralReceivedDate] DATETIME NULL,
    [SourceReferrerID] INT NULL,
    [SourceReferralID] INT NULL,
    [TeamID] INT NULL,
    [OrganisationID] INT NULL,
    [CurrentReferralStatusTypeID] INT NULL,
    [ReferralPriorityID] INT NULL,
    [ReferralExpectedArrivalDate] DATETIME NULL,
    [ReferralExpectedDepartureDate] DATETIME NULL,
    [ReferralActualArrivalDate] DATETIME NULL,
    [ReferralActualDepartureDate] DATETIME NULL,
    [ReferralEndDate] DATETIME NULL,
    [ReferralNotes] NVARCHAR (MAX) NULL,
    [OldReferralID] INT NULL,
    [OldMovementID] INT NULL,
    [ReferralUDF1] NVARCHAR (MAX) NULL,
    [ReferralUDF2] NVARCHAR (MAX) NULL,
    [ReferralUDF3] NVARCHAR (MAX) NULL,
    [ReferralUDF4] NVARCHAR (MAX) NULL,
    [ReferralUDF5] NVARCHAR (MAX) NULL,
    [InterviewUserID] INT NULL,
    [ReferralInterviewDate] DATETIME NULL,
    [ReferralCreatedUserID] INT NULL,
    [ReferralCreatedDate] DATETIME NULL,
    [ReferralReferralType] VARCHAR (32) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactReferral/landing',
    FILE_FORMAT = [parquet]
    );

