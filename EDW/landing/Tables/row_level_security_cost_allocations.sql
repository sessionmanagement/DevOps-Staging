CREATE TABLE [landing].[row_level_security_cost_allocations] (
    [employee_number]                    INT            NULL,
    [displayName]                        NVARCHAR (100) NULL,
    [email_address]                      NVARCHAR (200) NULL,
    [job_title]                          NVARCHAR (200) NULL,
    [intellihr_people_id]                NVARCHAR (36)  NULL,
    [datapay_cost_center_code]           VARCHAR (200)  NULL,
    [datapay_cost_center_name]           VARCHAR (200)  NULL,
    [datapay_cost_allocation_percentage] FLOAT (53)     NULL,
    [intellihr_business_unit_id]         NVARCHAR (36)  NULL,
    [intellihr_business_unit_name]       NVARCHAR (100) NULL,
    [intellihr_bc_code]                  NVARCHAR (200) NULL,
    [person_is_supervisor]               INT            NULL,
    [intellihr_job_title]                NVARCHAR (100) NULL,
    [intellihr_company_id]               NVARCHAR (36)  NULL,
    [intellihr_company_name]             NVARCHAR (200) NULL,
    [person_employeement_status]         NVARCHAR (50)  NULL
);

