CREATE TABLE [staging].[ODSETLdim_kpi_service_type] (
    [dim_kpi_service_type_key]        INT            IDENTITY (1, 1) NOT NULL,
    [service_type_id]                 INT            NULL,
    [service_type]                    NVARCHAR (255) NULL,
    [service_type_grouping_lookup_id] INT            NULL,
    [service_type_grouping]           NVARCHAR (255) NULL
);

