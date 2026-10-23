CREATE EXTERNAL TABLE [staging].[IntelliHR_people] (
    [people_id] NVARCHAR (36) NULL,
    [displayName] NVARCHAR (100) NULL,
    [firstName] NVARCHAR (75) NULL,
    [middleName] NVARCHAR (75) NULL,
    [lastName] NVARCHAR (100) NULL,
    [preferredName] NVARCHAR (75) NULL,
    [dateOfBirth] DATETIME2 (7) NULL,
    [gender] NVARCHAR (50) NULL,
    [isSupervisor] INT NULL,
    [employeeNumber] INT NULL,
    [autoIncrementIntellihrId] INT NULL,
    [title] NVARCHAR (10) NULL,
    [emergencyContact_name] NVARCHAR (150) NULL,
    [emergencyContact_relationship] NVARCHAR (100) NULL,
    [emergencyContact_phone] NVARCHAR (200) NULL,
    [emergencyContact_email] NVARCHAR (100) NULL,
    [employmentStatus] NVARCHAR (50) NULL,
    [workRights_name] NVARCHAR (100) NULL,
    [workRights_country] NVARCHAR (50) NULL,
    [workRights_expirationDate] DATETIME2 (7) NULL,
    [primaryEmailAddress_email] NVARCHAR (100) NULL,
    [primaryEmailAddress_isPersonal] INT NULL,
    [primaryPhoneNumber_number] NVARCHAR (200) NULL,
    [primaryPhoneNumber_fullNumber] NVARCHAR (200) NULL,
    [primaryPhoneNumber_isPersonal] INT NULL,
    [createdAt] DATETIME2 (7) NULL,
    [updatedAt] DATETIME2 (7) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/people/staging',
    FILE_FORMAT = [parquet]
    );

