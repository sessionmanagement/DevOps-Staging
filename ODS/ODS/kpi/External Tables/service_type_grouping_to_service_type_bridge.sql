CREATE EXTERNAL TABLE [kpi].[service_type_grouping_to_service_type_bridge] (
    [service_type_grouping_id] INT NULL,
    [service_type_id] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'kpi/service_type_grouping_to_service_type_bridge/main',
    FILE_FORMAT = [parquet]
    );

