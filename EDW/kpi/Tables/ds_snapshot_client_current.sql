CREATE TABLE [kpi].[ds_snapshot_client_current] (
    [kpi_snapshot_client_id]          INT            IDENTITY (1, 1) NOT NULL,
    [dim_kpi_key]                     INT            NOT NULL,
    [dim_company_key]                 TINYINT        NULL,
    [dim_client_key]                  INT            NOT NULL,
    [entity_key]                      VARCHAR (20)   NULL,
    [dim_service_key]                 INT            NOT NULL,
    [kpi_id]                          INT            NULL,
    [client_id]                       INT            NULL,
    [service_id]                      INT            NULL,
    [kpi_value]                       NUMERIC (6, 2) NULL,
    [user_friendly_score_explanation] VARCHAR (200)  NULL,
    [kpi_status]                      TINYINT        NULL,
    [snapshot_date]                   DATE           NULL,
    [KPIBatchID]                      INT            NULL,
    CONSTRAINT [PK__kpi_ds_snapshot_client_current] PRIMARY KEY NONCLUSTERED ([kpi_snapshot_client_id] ASC)
);

