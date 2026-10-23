CREATE EXTERNAL TABLE [IntelliHR].[users_permission] (
    [users_id] NVARCHAR (36) NULL,
    [userPermissionGroups_id] NVARCHAR (36) NULL,
    [permissionGroup_id] NVARCHAR (36) NULL,
    [permissionGroup_name] NVARCHAR (150) NULL,
    [permissionGroup_isEnabled] INT NULL,
    [ODSIsCurrent] INT,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSDMLOperation] VARCHAR (1),
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/users_permission/main',
    FILE_FORMAT = [parquet]
    );

