CREATE TABLE [edw].[row_level_security] (
    [employee_number]            INT            NULL,
    [employee_display_name]      NVARCHAR (100) NULL,
    [employee_email]             NVARCHAR (100) NULL,
    [job_title]                  NVARCHAR (100) NULL,
    [employee_employment_status] NVARCHAR (50)  NULL,
    [manager_employee_number]    INT            NULL,
    [manager_display_name]       NVARCHAR (100) NULL,
    [manager_job_title]          NVARCHAR (100) NULL,
    [manager_email]              NVARCHAR (100) NULL,
    [manager_employment_status]  NVARCHAR (50)  NULL,
    [intellihr_business_unit_id] NVARCHAR (36)  NULL,
    [business_unit_name]         NVARCHAR (100) NULL,
    [intellihr_bc_code]          NVARCHAR (200) NULL,
    [intellihr_company_id]       NVARCHAR (36)  NULL,
    [intellihr_company_name]     NVARCHAR (50)  NULL,
    [dim_service_key]            INT            NULL,
    [recordbase_team_name]       NVARCHAR (250) NULL,
    [recordbase_team_id]         INT            NULL,
    [recordbase_company_name]    NVARCHAR (200) NULL,
    [dim_client_team_key]        INT            NULL
);



