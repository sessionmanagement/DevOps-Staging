CREATE EXTERNAL TABLE [landing].[RBMNB_dlFactUserRole] (
    [UserRoleID] INT NULL,
    [UserID] INT NULL,
    [RoleID] INT NULL,
    [UserRoleCreatedDate] DATETIME NULL,
    [UserRoleCreatedUserID] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactUserRole/landing',
    FILE_FORMAT = [parquet]
    );

