CREATE TABLE [landing].[edw_fact_employee_pay_slip] (
    [pay_packet_id]          INT        NULL,
    [employee_id]            INT        NULL,
    [gross_total_amount]     FLOAT (53) NULL,
    [deduction_total_amount] FLOAT (53) NULL,
    [net_total_amount]       FLOAT (53) NULL,
    [pay_run_date]           DATE       NULL,
    [pay_period_start_date]  DATE       NULL,
    [pay_period_end_date]    DATE       NULL,
    [company_code]           INT        NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [fact_employee_pay_slip]
    ON [landing].[edw_fact_employee_pay_slip]([pay_packet_id] ASC, [employee_id] ASC, [company_code] ASC);

