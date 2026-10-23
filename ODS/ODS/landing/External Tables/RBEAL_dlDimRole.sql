CREATE EXTERNAL TABLE [landing].[RBEAL_dlDimRole] (
    [RoleID] INT NULL,
    [RoleName] VARCHAR (50) NULL,
    [RoleDescription] VARCHAR (100) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimRole/landing',
    FILE_FORMAT = [parquet]
    );

