CREATE TABLE [edw].[fact_employee_kpi_commentary] (
    [fact_employee_kpi_commentary_key] INT             IDENTITY (1, 1) NOT NULL,
    [dim_kpi_key]                      INT             NULL,
    [dim_company_key]                  INT             NULL,
    [dim_employee_key]                 INT             NULL,
    [dim_service_key]                  INT             NULL,
    [response_id]                      BIGINT          NULL,
    [measure_selected]                 NVARCHAR (500)  NULL,
    [commentary]                       NVARCHAR (1000) NULL,
    [company_id]                       INT             NULL,
    [service_id]                       INT             NULL,
    [kpi_id]                           INT             NULL,
    [responder]                        NVARCHAR (255)  NULL,
    [submitted_date]                   DATETIME2 (7)   NULL,
    [DWHCreatedAt]                     DATETIME        NULL,
    [DWHBatchId]                       INT             NULL,
    [DWHSourceSystem]                  NVARCHAR (120)  NULL,
    CONSTRAINT [PK__edw_fact_employee_kpi_commentary] PRIMARY KEY NONCLUSTERED ([fact_employee_kpi_commentary_key] ASC)
);

