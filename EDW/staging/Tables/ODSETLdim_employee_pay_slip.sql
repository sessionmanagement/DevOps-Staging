CREATE TABLE [staging].[ODSETLdim_employee_pay_slip] (
    [ODSdim_employee_pay_slipID]        INT           IDENTITY (1, 1) NOT NULL,
    [dim_company_key_pay_packet_id_key] BIGINT        NULL,
    [dim_company_key]                   INT           NOT NULL,
    [pay_packet_id]                     INT           NULL,
    [pay_packet_type]                   NVARCHAR (50) NULL,
    [pay_run_date]                      DATE          NULL,
    [pay_period_start_date]             DATE          NULL,
    [pay_period_end_date]               DATE          NULL,
    [company_code]                      INT           NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLdim_employee_pay_slip] PRIMARY KEY NONCLUSTERED ([ODSdim_employee_pay_slipID] ASC)
);

