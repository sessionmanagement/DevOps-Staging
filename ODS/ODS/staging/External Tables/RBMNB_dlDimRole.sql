CREATE EXTERNAL TABLE [staging].[RBMNB_dlDimRole] (
    [RoleID] INT NULL,
    [RoleName] VARCHAR (50) NULL,
    [RoleDescription] VARCHAR (200) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimRole/staging',
    FILE_FORMAT = [parquet]
    );

