CREATE TABLE [staging].[ODSETLbridge_kpi_service_type_to_grouping] (
    [ODSbridge_kpi_service_type_to_grouping_key] INT IDENTITY (1, 1) NOT NULL,
    [dim_kpi_service_type_key]                   INT NOT NULL,
    [dim_kpi_service_type_grouping_key]          INT NOT NULL,
    [service_type_grouping_id]                   INT NULL,
    [service_type_id]                            INT NULL
);

