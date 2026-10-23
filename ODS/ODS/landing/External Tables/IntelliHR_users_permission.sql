CREATE EXTERNAL TABLE [landing].[IntelliHR_users_permission] (
    [users_id] NVARCHAR (36) NULL,
    [userPermissionGroups_id] NVARCHAR (36) NULL,
    [permissionGroup_id] NVARCHAR (36) NULL,
    [permissionGroup_name] NVARCHAR (150) NULL,
    [permissionGroup_isEnabled] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/users_permission/landing',
    FILE_FORMAT = [parquet]
    );

