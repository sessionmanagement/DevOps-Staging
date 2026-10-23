CREATE EXTERNAL TABLE [working].[On_Call_service] (
    [service_id] INT NULL,
    [service_title] NVARCHAR (100) NULL,
    [service_name] NVARCHAR (100) NULL,
    [service_manager_id] INT NULL,
    [region_id] INT NULL,
    [author_id] INT NULL,
    [editor_id] INT NULL,
    [is_active] NVARCHAR (10) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'On_Call/service/working',
    FILE_FORMAT = [parquet]
    );

