CREATE TABLE [staging].[ODSETLbridge_kpi_measure_to_service_type_group] (
    [bridge_kpi_measure_to_service_type_group_key] INT IDENTITY (1, 1) NOT NULL,
    [dim_kpi_key]                                  INT NULL,
    [measure_id]                                   INT NULL,
    [dim_kpi_service_type_grouping_key]            INT NULL,
    [service_type_grouping_id]                     INT NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLbridge_kpi_measure_to_service_type_group] PRIMARY KEY NONCLUSTERED ([bridge_kpi_measure_to_service_type_group_key] ASC)
);

