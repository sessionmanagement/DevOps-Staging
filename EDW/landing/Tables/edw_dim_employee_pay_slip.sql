CREATE TABLE [landing].[edw_dim_employee_pay_slip] (
    [pay_packet_id]         INT           NULL,
    [pay_packet_type]       NVARCHAR (50) NULL,
    [pay_run_date]          DATE          NULL,
    [pay_period_start_date] DATE          NULL,
    [pay_period_end_date]   DATE          NULL,
    [company_code]          INT           NULL,
    [company_name]          NVARCHAR (50) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [dim_employee_pay_slip]
    ON [landing].[edw_dim_employee_pay_slip]([pay_packet_id] ASC, [company_code] ASC);

