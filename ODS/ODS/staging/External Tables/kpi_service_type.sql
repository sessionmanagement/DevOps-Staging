CREATE EXTERNAL TABLE [staging].[kpi_service_type] (
    [id] INT NULL,
    [service_type] NVARCHAR (255) NULL,
    [service_type_grouping_lookup_id] INT NULL,
    [service_type_grouping] NVARCHAR (255) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'kpi/service_type/staging',
    FILE_FORMAT = [parquet]
    );

