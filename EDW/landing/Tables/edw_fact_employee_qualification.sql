CREATE TABLE [landing].[edw_fact_employee_qualification] (
    [qualification_instance_id]         NVARCHAR (36)   NULL,
    [expiry_date]                       DATETIME2 (7)   NULL,
    [issue_date]                        DATETIME2 (7)   NULL,
    [issuing_organisation]              NVARCHAR (200)  NULL,
    [notes]                             NVARCHAR (2000) NULL,
    [employee_id]                       INT             NULL,
    [service_name]                      NVARCHAR (100)  NULL,
    [company_name]                      NVARCHAR (100)  NULL,
    [person_link]                       NVARCHAR (36)   NULL,
    [qualification_status]              NVARCHAR (50)   NULL,
    [employee_qualification_library_id] NVARCHAR (36)   NULL,
    [employee_qualification_requirement_flag] INT       NULL,
    [employee_qualification_type_id]    NVARCHAR (36)   NULL,
    [qualification_library_item_link]   NVARCHAR (36)   NULL,
    [registration_number]               NVARCHAR (80)   NULL
);

