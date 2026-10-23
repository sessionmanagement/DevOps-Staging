CREATE EXTERNAL TABLE [staging].[RBMNB_dlFactPersonDependant] (
    [PersonDependantID] INT NULL,
    [PersonID] INT NULL,
    [PersonDependantName] NVARCHAR (50) NULL,
    [PersonDependantProxyDateOfBirth] DATETIME NULL,
    [GenderID] INT NULL,
    [CustodyID] INT NULL,
    [OldChildID] INT NULL,
    [PersonDependantCreatedDate] DATETIME NULL,
    [PersonDependantCreatedUserID] INT NULL,
    [PersonDependantDateOfBirth] DATETIME2 (7) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactPersonDependant/staging',
    FILE_FORMAT = [parquet]
    );

