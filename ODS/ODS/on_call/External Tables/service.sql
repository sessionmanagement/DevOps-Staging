CREATE EXTERNAL TABLE [on_call].[service] (
    [service_id] INT NULL,
    [service_title] NVARCHAR (100) NULL,
    [service_name] NVARCHAR (100) NULL,
    [service_manager_id] INT NULL,
    [region_id] INT NULL,
    [author_id] INT NULL,
    [editor_id] INT NULL,
    [is_active] NVARCHAR (10) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'On_Call/service/main',
    FILE_FORMAT = [parquet]
    );

