CREATE TABLE [landing].[edw_fact_employee_kpi_commentary] (
    [response_id]      BIGINT          NULL,
    [measure_selected] NVARCHAR (500)  NULL,
    [commentary]       NVARCHAR (1000) NULL,
    [company_id]       INT             NULL,
    [service_id]       INT             NULL,
    [kpi_id]           INT             NULL,
    [responder]        NVARCHAR (255)  NULL,
    [submitted_date]   DATETIME2 (7)   NULL
);

