CREATE TABLE [landing].[kpi_ds_snapshot_kaimahi] (
    [dim_company_key]        INT            NULL,
    [dim_employee_key]       INT            NULL,
    [dim_service_key]        INT            NULL,
    [kpi_value]              FLOAT (53)     NULL,
    [kpi_name]               NVARCHAR (MAX) NULL,
    [kaimahi_id]             INT            NULL,
    [green_threshold]        NVARCHAR (MAX) NULL,
    [amber_threshold]        NVARCHAR (MAX) NULL,
    [green_sign]             NVARCHAR (MAX) NULL,
    [amber_sign]             NVARCHAR (MAX) NULL,
    [rollup_green_threshold] NVARCHAR (MAX) NULL,
    [rollup_green_sign]      NVARCHAR (MAX) NULL,
    [rollup_amber_threshold] NVARCHAR (MAX) NULL,
    [rollup_amber_sign]      NVARCHAR (MAX) NULL,
    [dim_kpi_key]            INT            NULL,
    [entity_key]             NVARCHAR (60)  NULL,
    [KPI Status]             VARCHAR (5)    NULL
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_kpi_snapshot_kaimahi]
    ON [landing].[kpi_ds_snapshot_kaimahi]([dim_company_key] ASC, [dim_employee_key] ASC, [dim_service_key] ASC, [dim_kpi_key] ASC);

