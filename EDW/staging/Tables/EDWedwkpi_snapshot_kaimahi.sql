CREATE TABLE [staging].[EDWedwkpi_snapshot_kaimahi] (
    [EDWkpi_snapshot_kaimahiID]       INT            IDENTITY (1, 1) NOT NULL,
    [dim_kpi_key]                     INT            NULL,
    [dim_company_key]                 TINYINT        NULL,
    [dim_employee_key]                INT            NOT NULL,
    [dim_service_key]                 INT            NULL,
    [entity_key]                      VARCHAR (20)   NULL,
    [kpi_id]                          INT            NULL,
    [employee_id]                     INT            NULL,
    [service_id]                      INT            NULL,
    [kpi_value]                       NUMERIC (6, 2) NULL,
    [user_friendly_score_explanation] VARCHAR (200)  NULL,
    [kpi_status]                      TINYINT        NULL,
    [snapshot_date]                   DATE           NULL,
    CONSTRAINT [PK_Temp_Staging_EDWedwkpi_snapshot_kaimahi] PRIMARY KEY NONCLUSTERED ([EDWkpi_snapshot_kaimahiID] ASC)
);

