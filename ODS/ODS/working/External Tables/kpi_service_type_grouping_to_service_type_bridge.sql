CREATE EXTERNAL TABLE [working].[kpi_service_type_grouping_to_service_type_bridge] (
    [service_type_grouping_id] INT NULL,
    [service_type_id] INT NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'kpi/service_type_grouping_to_service_type_bridge/working',
    FILE_FORMAT = [parquet]
    );

