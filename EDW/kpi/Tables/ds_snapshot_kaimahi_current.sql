CREATE TABLE [kpi].[ds_snapshot_kaimahi_current] (
    [kpi_snapshot_kaimahi_id]         INT            IDENTITY (1, 1) NOT NULL,
    [dim_kpi_key]                     INT            NULL,
    [dim_company_key]                 TINYINT        NULL,
    [dim_employee_key]                INT            NOT NULL,
    [dim_service_key]                 INT            NULL,
    [kpi_id]                          INT            NULL,
    [employee_id]                     INT            NULL,
    [service_id]                      INT            NULL,
    [entity_key]                      VARCHAR (20)   NULL,
    [kpi_value]                       NUMERIC (6, 2) NULL,
    [user_friendly_score_explanation] VARCHAR (200)  NULL,
    [kpi_status]                      TINYINT        NULL,
    [snapshot_date]                   DATE           NULL,
    [KPIBatchID]                      INT            NULL,
    CONSTRAINT [PK_kpi_ds_snapshot_kaimahi_current] PRIMARY KEY NONCLUSTERED ([kpi_snapshot_kaimahi_id] ASC)
);

