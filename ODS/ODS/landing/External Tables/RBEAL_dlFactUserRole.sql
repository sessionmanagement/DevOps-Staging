CREATE EXTERNAL TABLE [landing].[RBEAL_dlFactUserRole] (
    [UserRoleID] INT NULL,
    [UserID] INT NULL,
    [RoleID] INT NULL,
    [UserRoleCreatedDate] DATETIME NULL,
    [UserRoleCreatedUserID] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlFactUserRole/landing',
    FILE_FORMAT = [parquet]
    );

