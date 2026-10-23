CREATE TABLE [landing].[edw_dim_employee_pay_run] (
    [pay_run_id]            INT           NULL,
    [pay_run_type]          NVARCHAR (50) NULL,
    [pay_run_status]        NVARCHAR (20) NULL,
    [pay_run_date]          DATE          NULL,
    [pay_period_start_date] DATE          NULL,
    [pay_period_end_date]   DATE          NULL,
    [company_code]          INT           NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [dim_employee_pay_run]
    ON [landing].[edw_dim_employee_pay_run]([pay_run_id] ASC, [company_code] ASC);

