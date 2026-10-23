CREATE EXTERNAL TABLE [kpi].[service_type] (
    [id] INT NULL,
    [service_type] NVARCHAR (255) NULL,
    [service_type_grouping_lookup_id] INT NULL,
    [service_type_grouping] NVARCHAR (255) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'kpi/service_type/main',
    FILE_FORMAT = [parquet]
    );

