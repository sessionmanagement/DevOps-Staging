CREATE TABLE [landing].[edw_fact_employee_pay_run_item] (
    [pay_run_id]             BIGINT          NULL,
    [employee_id]            INT             NULL,
    [pay_component_code]     NVARCHAR (1000) NULL,
    [pay_component_name]     NVARCHAR (1000) NULL,
    [pay_component_category] NVARCHAR (1000) NULL,
    [pay_period_start_date]  DATE            NULL,
    [pay_period_end_date]    DATE            NULL,
    [hours_amount]           FLOAT (53)      NULL,
    [total_amount]           FLOAT (53)      NULL,
    [division_code]          NVARCHAR (500)  NULL,
    [cost_centre_code]       NVARCHAR (500)  NULL,
    [department_code]        NVARCHAR (500)  NULL,
    [sub_department_code]    NVARCHAR (500)  NULL,
    [department]             NVARCHAR (500)  NULL,
    [sub_department]         NVARCHAR (500)  NULL,
    [remuneration_type]      NVARCHAR (250)  NULL,
    [work_class]             NVARCHAR (250)  NULL,
    [work_type]              NVARCHAR (250)  NULL,
    [company_code]           INT             NULL
);


GO
CREATE NONCLUSTERED INDEX [fact_employee_pay_run_item]
    ON [landing].[edw_fact_employee_pay_run_item]([pay_run_id] ASC, [employee_id] ASC, [pay_component_code] ASC, [company_code] ASC);

