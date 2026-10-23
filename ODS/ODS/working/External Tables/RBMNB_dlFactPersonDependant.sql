CREATE EXTERNAL TABLE [working].[RBMNB_dlFactPersonDependant] (
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
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactPersonDependant/working',
    FILE_FORMAT = [parquet]
    );

