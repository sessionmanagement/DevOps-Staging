CREATE EXTERNAL TABLE [RBEAL].[dlFactPersonDependant] (
    [PersonDependantID] INT NULL,
    [PersonID] INT NULL,
    [PersonDependantName] NVARCHAR (50) NULL,
    [PersonDependantProxyDateOfBirth] DATETIME NULL,
    [GenderID] INT NULL,
    [CustodyID] INT NULL,
    [OldChildID] INT NULL,
    [PersonDependantCreatedDate] DATETIME NULL,
    [PersonDependantCreatedUserID] INT NULL,
    [PersonDependantDateOfBirth] DATETIME2 (7) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactPersonDependant/main',
    FILE_FORMAT = [parquet]
    );

