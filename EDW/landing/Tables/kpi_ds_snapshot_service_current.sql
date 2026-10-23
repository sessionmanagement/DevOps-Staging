CREATE TABLE [landing].[kpi_ds_snapshot_service_current] (
    [dim_kpi_key]                     INT            NULL,
    [dim_company_key]                 INT            NULL,
    [dim_service_key]                 INT            NULL,
    [entity_key]                      VARCHAR (50)   NULL,
    [kpi_id]                          INT            NULL,
    [service_id]                      INT            NULL,
    [kpi_value]                       NUMERIC (6, 2) NULL,
    [user_friendly_score_explanation] VARCHAR (200)  NULL,
    [kpi_status]                      INT            NULL,
    [snapshot_date]                   DATE           NULL
);

