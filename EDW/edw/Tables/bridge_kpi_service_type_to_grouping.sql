CREATE TABLE [edw].[bridge_kpi_service_type_to_grouping] (
    [bridge_kpi_service_type_to_grouping_key] INT            IDENTITY (1, 1) NOT NULL,
    [dim_kpi_service_type_key]                INT            NOT NULL,
    [dim_kpi_service_type_grouping_key]       INT            NOT NULL,
    [service_type_grouping_id]                INT            NULL,
    [service_type_id]                         INT            NULL,
    [DWHCreatedAt]                            DATETIME       NULL,
    [DWHBatchId]                              INT            NULL,
    [DWHSourceSystem]                         NVARCHAR (120) NULL,
    CONSTRAINT [PK__edw_bridge_kpi_service_type_to_grouping_key] PRIMARY KEY NONCLUSTERED ([bridge_kpi_service_type_to_grouping_key] ASC)
);



