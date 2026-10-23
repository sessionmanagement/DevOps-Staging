CREATE EXTERNAL TABLE [working].[IntelliHR_users_permission] (
    [users_id] NVARCHAR (36) NULL,
    [userPermissionGroups_id] NVARCHAR (36) NULL,
    [permissionGroup_id] NVARCHAR (36) NULL,
    [permissionGroup_name] NVARCHAR (150) NULL,
    [permissionGroup_isEnabled] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSBatchId] INT NULL,
    [ODSDMLOperation] CHAR (1) NULL,
    [ODSEffectiveFrom] DATETIME NULL,
    [ODSEffectiveTo] DATETIME NULL,
    [ODSIsCurrent] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/users_permission/working',
    FILE_FORMAT = [parquet]
    );

