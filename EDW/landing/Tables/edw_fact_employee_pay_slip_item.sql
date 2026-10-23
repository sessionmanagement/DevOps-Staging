CREATE TABLE [landing].[edw_fact_employee_pay_slip_item] (
    [pay_packet_id]     INT             NULL,
    [pay_packet_row_id] NVARCHAR (4000) NULL,
    [employee_id]       INT             NULL,
    [item_type]         VARCHAR (9)     NULL,
    [item_amount]       FLOAT (53)      NULL,
    [item_type_detail]  NVARCHAR (100)  NULL,
    [item_summary]      NVARCHAR (4000) NULL,
    [company_code]      INT             NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [fact_employee_pay_slip_item]
    ON [landing].[edw_fact_employee_pay_slip_item]([pay_packet_id] ASC, [pay_packet_row_id] ASC, [employee_id] ASC, [company_code] ASC);

