CREATE EXTERNAL TABLE [landing].[RBMNB_dlDimRole] (
    [RoleID] INT NULL,
    [RoleName] VARCHAR (50) NULL,
    [RoleDescription] NVARCHAR (200) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBMNB/dlDimRole/landing',
    FILE_FORMAT = [parquet]
    );

