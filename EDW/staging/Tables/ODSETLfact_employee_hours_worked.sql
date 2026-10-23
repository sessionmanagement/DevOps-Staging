CREATE TABLE [staging].[ODSETLfact_employee_hours_worked] (
    [ODSfact_employee_hours_workedID]             INT             IDENTITY (1, 1) NOT NULL,
    [dim_company_key]                             INT             NOT NULL,
    [dim_employee_key]                            INT             NOT NULL,
    [dim_ethnicity_key]                           INT             NOT NULL,
    [dim_payroll_category_key]                    INT             NOT NULL,
    [dim_leave_type_key]                          INT             NOT NULL,
    [dim_shift_start_date_key]                    INT             NOT NULL,
    [dim_shift_end_date_key]                      INT             NOT NULL,
    [dim_shift_start_time_key]                    INT             NOT NULL,
    [dim_shift_end_time_key]                      INT             NOT NULL,
    [time_sheet_entry_id]                         NVARCHAR (36)   NULL,
    [fact_hours_worked_company_name]              NVARCHAR (255)  NULL,
    [fact_hours_worked_payroll_category_id]       NVARCHAR (36)   NULL,
    [fact_hours_worked_employee_number]           NVARCHAR (20)   NULL,
    [fact_hours_worked_leave_type_name]           NVARCHAR (255)  NULL,
    [fact_hours_worked_emplive_service_id]        NVARCHAR (36)   NULL,
    [fact_hours_worked_concatenated_ethnicity_id] NVARCHAR (4000) NULL,
    [fact_hours_worked_total_duration]            REAL            NULL,
    [fact_hours_worked_approval_status]           NVARCHAR (100)  NULL,
    [fact_hours_worked_role]                      NVARCHAR (100)  NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLfact_employee_hours_worked] PRIMARY KEY NONCLUSTERED ([ODSfact_employee_hours_workedID] ASC)
);



