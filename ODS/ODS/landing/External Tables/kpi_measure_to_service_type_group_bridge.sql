CREATE EXTERNAL TABLE [landing].[kpi_measure_to_service_type_group_bridge] (
    [measure_id] INT NULL,
    [service_type_grouping_id] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'kpi/measure_to_service_type_group_bridge/landing',
    FILE_FORMAT = [parquet]
    );

