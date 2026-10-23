CREATE TABLE [landing].[edw_fact_employee_leave] (
    [datapay_company_id]                    NVARCHAR (50)   NOT NULL,
    [employee_id]                           INT             NOT NULL,
    [leave_type_id]                         NVARCHAR (50)   NOT NULL,
    [dim_ethnicity_id]                      NVARCHAR (4000) NULL,
    [employee_leave_effective_date_key]     INT             NOT NULL,
    [employee_leave_anniversary_date_key]   INT             NULL,
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






GO
CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_edw_fact_employee_leave]
    ON [landing].[edw_fact_employee_leave]([datapay_company_id] ASC, [employee_id] ASC, [leave_type_id] ASC, [employee_leave_effective_date_key] ASC);

