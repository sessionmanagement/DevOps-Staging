CREATE EXTERNAL TABLE [landing].[kpi_service_type_grouping_to_service_type_bridge] (
    [service_type_grouping_id] INT NULL,
    [service_type_id] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'kpi/service_type_grouping_to_service_type_bridge/landing',
    FILE_FORMAT = [parquet]
    );

