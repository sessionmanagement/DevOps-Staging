CREATE TABLE [staging].[ODSETLfact_employee_leave] (
    [ODSfact_employee_leaveID]              INT             IDENTITY (1, 1) NOT NULL,
    [dim_company_key]                       INT             NOT NULL,
    [dim_business_unit_hierarchy_key]       INT             NOT NULL,
    [dim_employee_key]                      INT             NOT NULL,
    [dim_leave_type_key]                    INT             NOT NULL,
    [dim_ethnicity_key]                     INT             NOT NULL,
    [dim_payroll_category_key]              INT             NOT NULL,
    [employee_leave_effective_date_key]     INT             NULL,
    [employee_leave_anniversary_date_key]   INT             NULL,
    [datapay_company_id]                    NVARCHAR (50)   NULL,
    [employee_id]                           INT             NULL,
    [leave_type_id]                         NVARCHAR (50)   NULL,
    [ethnicity_id]                          NVARCHAR (4000) NULL,
    [business_unit_id]                      NVARCHAR (36)   NOT NULL,
    [business_unit_name]                    NVARCHAR (50)   NULL,
    [employee_leave_unit]                   NVARCHAR (50)   NULL,
    [employee_leave_entitlement]            REAL            NULL,
    [employee_leave_accrual]                REAL            NULL,
    [employee_leave_taken]                  REAL            NULL,
    [employee_leave_balance]                REAL            NULL,
    [employee_leave_entitlement_hours]      REAL            NULL,
    [employee_leave_accrual_hours]          REAL            NULL,
    [employee_leave_taken_hours]            REAL            NULL,
    [employee_leave_balance_hours]          REAL            NULL,
    [employee_leave_next_entitlement_hours] REAL            NULL
);



