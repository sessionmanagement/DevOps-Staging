CREATE TABLE [landing].[edw_fact_employee_hours_worked] (
    [time_sheet_entry_id]                                NVARCHAR (36)   NULL,
    [fact_hours_worked_company_name]                     NVARCHAR (255)  NULL,
    [fact_hours_worked_payroll_category_id]              NVARCHAR (36)   NULL,
    [fact_hours_worked_employee_number]                  NVARCHAR (20)   NULL,
    [fact_hours_worked_leave_type_name]                  NVARCHAR (255)  NULL,
    [fact_hours_worked_emplive_service_id]               NVARCHAR (36)   NULL,
    [fact_hours_worked_concatenated_ethnicity_id]        NVARCHAR (4000) NULL,
    [fact_hours_worked_total_duration]                   REAL            NULL,
    [fact_hours_worked_approval_status]                  NVARCHAR (100)  NULL,
    [fact_hours_worked_concatenated_shift_start_date_id] INT             NULL,
    [fact_hours_worked_concatenated_shift_end_date_id]   INT             NULL,
    [fact_hours_worked_concatenated_shift_start_time_id] TIME (0)        NULL,
    [fact_hours_worked_concatenated_shift_end_time_id]   TIME (0)        NULL,
    [fact_hours_worked_role]                             NVARCHAR (100)  NULL
);



