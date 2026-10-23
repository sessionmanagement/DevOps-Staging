CREATE EXTERNAL TABLE [RBEAL].[dlDimRole] (
    [RoleID] INT NULL,
    [RoleName] VARCHAR (50) NULL,
    [RoleDescription] VARCHAR (200) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'RBEAL/dlDimRole/main',
    FILE_FORMAT = [parquet]
    );

