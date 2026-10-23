CREATE TABLE [kpi].[fact_kpi_history] (
    [fact_kpi_history_key]            INT              IDENTITY (1, 1) NOT NULL,
    [fact_kpi_id]                     INT              NOT NULL,
    [dim_kpi_key]                     INT              NOT NULL,
    [dim_company_key]                 TINYINT          NULL,
    [dim_employee_key]                INT              NULL,
    [dim_client_key]                  INT              NULL,
    [dim_client_referral_key]         INT              NULL,
    [dim_property_key]                INT              NULL,
    [dim_property_tenancy_key]        INT              NULL,
    [dim_service_key]                 INT              NOT NULL,
    [kpi_id]                          INT              NULL,
    [service_id]                      INT              NULL,
    [employee_id]                     INT              NULL,
    [client_id]                       INT              NULL,
    [client_referral_id]              INT              NULL,
    [property_id]                     UNIQUEIDENTIFIER NULL,
    [property_tenancy_id]             UNIQUEIDENTIFIER NULL,
    [entity_key]                      VARCHAR (50)     NULL,
    [kpi_value]                       NUMERIC (8, 2)   NULL,
    [user_friendly_score_explanation] VARCHAR (200)    NULL,
    [kpi_status]                      TINYINT          NULL,
    [snapshot_date]                   DATE             NOT NULL,
    [archive_date]                    DATETIME2 (7)    DEFAULT (getdate()) NOT NULL,
    [archive_batch_id]                INT              NULL,
    CONSTRAINT [PK_kpi_fact_kpi_history] PRIMARY KEY CLUSTERED ([fact_kpi_history_key] ASC)
);








GO
CREATE NONCLUSTERED INDEX [IX_kpi_fact_kpi_history_archive_date]
    ON [kpi].[fact_kpi_history]([archive_date] DESC);


GO
CREATE NONCLUSTERED INDEX [IX_kpi_fact_kpi_history_dim_kpi_key]
    ON [kpi].[fact_kpi_history]([dim_kpi_key] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_kpi_fact_kpi_history_snapshot_date]
    ON [kpi].[fact_kpi_history]([snapshot_date] DESC);

