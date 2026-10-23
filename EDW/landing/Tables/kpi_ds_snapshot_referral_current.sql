CREATE TABLE [landing].[kpi_ds_snapshot_referral_current] (
    [dim_kpi_key]                     INT            NULL,
    [dim_company_key]                 TINYINT        NULL,
    [dim_client_referral_key]         INT            NOT NULL,
    [dim_service_key]                 INT            NULL,
    [entity_key]                      VARCHAR (50)   NULL,
    [kpi_id]                          INT            NULL,
    [client_referral_id]              INT            NULL,
    [service_id]                      INT            NULL,
    [kpi_value]                       NUMERIC (6, 2) NULL,
    [user_friendly_score_explanation] VARCHAR (200)  NULL,
    [kpi_status]                      TINYINT        NULL,
    [snapshot_date]                   DATE           NULL
);








GO
CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_kpi_snapshot_referral]
    ON [landing].[kpi_ds_snapshot_referral_current]([dim_company_key] ASC, [client_referral_id] ASC, [service_id] ASC, [dim_kpi_key] ASC);

