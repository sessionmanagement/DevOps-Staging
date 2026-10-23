CREATE EXTERNAL TABLE [kpi].[measure_to_service_type_group_bridge] (
    [measure_id] INT NULL,
    [service_type_grouping_id] INT NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'kpi/measure_to_service_type_group_bridge/main',
    FILE_FORMAT = [parquet]
    );

