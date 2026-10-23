CREATE EXTERNAL TABLE [working].[kpi_measure_to_service_type_group_bridge] (
    [measure_id] INT NULL,
    [service_type_grouping_id] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'kpi/measure_to_service_type_group_bridge/working',
    FILE_FORMAT = [parquet]
    );

