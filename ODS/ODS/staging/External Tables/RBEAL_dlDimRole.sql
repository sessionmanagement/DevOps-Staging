CREATE EXTERNAL TABLE [staging].[RBEAL_dlDimRole] (
    [RoleID] INT NULL,
    [RoleName] VARCHAR (50) NULL,
    [RoleDescription] VARCHAR (200) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimRole/staging',
    FILE_FORMAT = [parquet]
    );

