CREATE EXTERNAL TABLE [landing].[RBEAL_dlDimUser] (
    [UserID] INT NULL,
    [UserUsername] NVARCHAR (300) NULL,
    [UserFirstName] NVARCHAR (50) NULL,
    [UserLastName] NVARCHAR (50) NULL,
    [UserPreferredName] NVARCHAR (50) NULL,
    [UserEmailAddress] NVARCHAR (300) NULL,
    [UserPosition] NVARCHAR (50) NULL,
    [ReportsToUserID] INT NULL,
    [AspNetUserID] VARCHAR (100) NULL,
    [SID] VARCHAR (50) NULL,
    [UserEmployeeNumber] NVARCHAR (50) NULL,
    [OldUserID] INT NULL,
    [UserLicenceType] VARCHAR (50) NULL,
    [UserIsRecordbaseAdministrator] INT NULL,
    [UserIsChampion] INT NULL,
    [UserTypeID] INT NULL,
    [UserDisabledDate] DATETIME NULL,
    [DisabledUserID] INT NULL,
    [UserDisabledNotes] NVARCHAR (MAX) NULL,
    [UseriCalendarEnabled] INT NULL,
    [UseriCalendarToken] NVARCHAR (50) NULL,
    [UserIsVolunteer] INT NULL,
    [EmploymentTypeId] INT NULL,
    [UserFTE] DECIMAL (3, 1) NULL,
    [UserComments] NVARCHAR (MAX) NULL,
    [PersonId] INT NULL,
    [PositionId] INT NULL,
    [UserRecordbaseIdentitySubject] INT NULL,
    [UserCreatedUserID] INT NULL,
    [UserCreatedDate] DATETIME NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimUser/landing',
    FILE_FORMAT = [parquet]
    );

