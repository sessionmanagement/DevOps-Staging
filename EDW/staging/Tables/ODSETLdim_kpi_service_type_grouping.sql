CREATE TABLE [staging].[ODSETLdim_kpi_service_type_grouping] (
    [dim_kpi_service_type_grouping_key] INT            IDENTITY (1, 1) NOT NULL,
    [service_type_grouping_id]          INT            NULL,
    [service_type_group_name]           NVARCHAR (255) NULL,
    [service_type_grouping]             NVARCHAR (255) NULL,
    [notes]                             NVARCHAR (MAX) NULL
);

