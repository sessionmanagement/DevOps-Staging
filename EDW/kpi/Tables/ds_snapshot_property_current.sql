CREATE TABLE [kpi].[ds_snapshot_property_current] (
    [kpi_snapshot_property_id]        INT              IDENTITY (1, 1) NOT NULL,
    [dim_kpi_key]                     INT              NOT NULL,
    [dim_company_key]                 TINYINT          NULL,
    [dim_property_key]                INT              NOT NULL,
    [entity_key]                      VARCHAR (100)    NULL,
    [dim_service_key]                 INT              NOT NULL,
    [kpi_id]                          INT              NULL,
    [property_id]                     UNIQUEIDENTIFIER NULL,
    [service_id]                      INT              NULL,
    [kpi_value]                       NUMERIC (6, 2)   NULL,
    [user_friendly_score_explanation] VARCHAR (200)    NULL,
    [kpi_status]                      TINYINT          NULL,
    [snapshot_date]                   DATE             NULL,
    [KPIBatchID]                      INT              NULL,
    CONSTRAINT [PK__kpi_ds_snapshot_property_current] PRIMARY KEY NONCLUSTERED ([kpi_snapshot_property_id] ASC)
);

