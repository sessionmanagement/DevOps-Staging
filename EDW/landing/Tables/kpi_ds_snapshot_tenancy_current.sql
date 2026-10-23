CREATE TABLE [landing].[kpi_ds_snapshot_tenancy_current] (
    [dim_kpi_key]                     INT              NULL,
    [dim_company_key]                 TINYINT          NULL,
    [dim_property_tenancy_key]        INT              NULL,
    [dim_service_key]                 INT              NULL,
    [entity_key]                      VARCHAR (100)    NULL,
    [kpi_id]                          INT              NULL,
    [property_tenancy_id]             UNIQUEIDENTIFIER NULL,
    [service_id]                      INT              NULL,
    [kpi_value]                       NUMERIC (8, 2)   NULL,
    [user_friendly_score_explanation] VARCHAR (200)    NULL,
    [kpi_status]                      TINYINT          NULL,
    [snapshot_date]                   DATE             NULL
);

