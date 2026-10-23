CREATE EXTERNAL TABLE [landing].[On_Call_service] (
    [service_id] INT NULL,
    [service_title] NVARCHAR (100) NULL,
    [service_name] NVARCHAR (100) NULL,
    [service_manager_id] INT NULL,
    [region_id] INT NULL,
    [author_id] INT NULL,
    [editor_id] INT NULL,
    [is_active] NVARCHAR (10) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'On_Call/service/landing',
    FILE_FORMAT = [parquet]
    );

