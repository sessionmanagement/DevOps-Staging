CREATE EXTERNAL TABLE [landing].[IntelliHR_users] (
    [users_id] NVARCHAR (36) NULL,
    [username] NVARCHAR (100) NULL,
    [isEnabled] INT NULL,
    [createdAt] DATETIME2 (7) NULL,
    [updatedAt] DATETIME2 (7) NULL,
    [person_id] NVARCHAR (36) NULL,
    [person_displayName] NVARCHAR (100) NULL,
    [person_employeeNumber] INT NULL,
    [person_autoIncrementIntellihrId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/users/landing',
    FILE_FORMAT = [parquet]
    );

