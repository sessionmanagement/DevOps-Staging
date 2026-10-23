CREATE TABLE [edw].[fact_employee_hours_worked] (
    [fact_employee_hours_worked_key]              INT             IDENTITY (1, 1) NOT NULL,
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
    [DWHBatchId]                                  INT             NOT NULL,
    [DWHEffectiveFrom]                            DATETIME        NOT NULL,
    [DWHEffectiveTo]                              DATETIME        NOT NULL,
    [DWHDMLOperation]                             CHAR (1)        NOT NULL,
    [DWHIsCurrent]                                BIT             NOT NULL,
    [DWHSourceSystem]                             NVARCHAR (500)  NOT NULL,
    [fact_hours_worked_role]                      NVARCHAR (100)  NULL,
    CONSTRAINT [PK_edw_fact_employee_hours_worked] PRIMARY KEY NONCLUSTERED ([fact_employee_hours_worked_key] ASC)
);



