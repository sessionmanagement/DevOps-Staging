CREATE EXTERNAL TABLE [RBMNB].[dlFactUserRole] (
    [UserRoleID] INT NULL,
    [UserID] INT NULL,
    [RoleID] INT NULL,
    [UserRoleCreatedDate] DATETIME NULL,
    [UserRoleCreatedUserID] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlFactUserRole/main',
    FILE_FORMAT = [parquet]
    );

