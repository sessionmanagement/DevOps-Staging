CREATE EXTERNAL TABLE [working].[kpi_service_type_grouping] (
    [id] INT NULL,
    [service_type_group_name] NVARCHAR (255) NULL,
    [service_type_grouping] NVARCHAR (255) NULL,
    [notes] NVARCHAR (MAX) NULL,
    [ODSSourceSystem] NVARCHAR (500) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'kpi/service_type_grouping/working',
    FILE_FORMAT = [parquet]
    );

