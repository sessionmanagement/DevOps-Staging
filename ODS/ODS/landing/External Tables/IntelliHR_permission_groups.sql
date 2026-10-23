CREATE EXTERNAL TABLE [landing].[IntelliHR_permission_groups] (
    [permission_groups_id] NVARCHAR (36) NULL,
    [name] NVARCHAR (150) NULL,
    [isEnabled] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'IntelliHR/permission_groups/landing',
    FILE_FORMAT = [parquet]
    );

