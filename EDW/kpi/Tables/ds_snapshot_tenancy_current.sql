CREATE TABLE [kpi].[ds_snapshot_tenancy_current] (
    [kpi_snapshot_tenancy_id]         INT              IDENTITY (1, 1) NOT NULL,
    [dim_kpi_key]                     INT              NOT NULL,
    [dim_company_key]                 TINYINT          NULL,
    [dim_property_tenancy_key]        INT              NOT NULL,
    [entity_key]                      VARCHAR (100)    NULL,
    [dim_service_key]                 INT              NOT NULL,
    [kpi_id]                          INT              NULL,
    [property_tenancy_id]             UNIQUEIDENTIFIER NULL,
    [service_id]                      INT              NULL,
    [kpi_value]                       NUMERIC (8, 2)   NULL,
    [user_friendly_score_explanation] VARCHAR (200)    NULL,
    [kpi_status]                      TINYINT          NULL,
    [snapshot_date]                   DATE             NULL,
    [KPIBatchID]                      INT              NULL,
    CONSTRAINT [PK_kpi_ds_snapshot_tenancy_current] PRIMARY KEY CLUSTERED ([kpi_snapshot_tenancy_id] ASC)
);

