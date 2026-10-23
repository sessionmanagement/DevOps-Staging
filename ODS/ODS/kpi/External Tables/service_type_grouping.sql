CREATE EXTERNAL TABLE [kpi].[service_type_grouping] (
    [id] INT NULL,
    [service_type_group_name] NVARCHAR (255) NULL,
    [service_type_grouping] NVARCHAR (255) NULL,
    [notes] NVARCHAR (MAX) NULL,
    [ODSCreatedAt] DATETIME NULL,
    [ODSBatchId] INT NULL,
    [ODSSourceSystem] NVARCHAR (120) NULL
)
    WITH (
    DATA_SOURCE = [data],
    LOCATION = N'kpi/service_type_grouping/main',
    FILE_FORMAT = [parquet]
    );

