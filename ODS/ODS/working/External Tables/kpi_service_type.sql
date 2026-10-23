CREATE EXTERNAL TABLE [working].[kpi_service_type] (
    [id] INT NULL,
    [service_type] NVARCHAR (255) NULL,
    [service_type_grouping_lookup_id] INT NULL,
    [service_type_grouping] NVARCHAR (255) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'kpi/service_type/working',
    FILE_FORMAT = [parquet]
    );

