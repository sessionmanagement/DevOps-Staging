CREATE TABLE [edw].[dim_employee_pay_run] (
    [dim_employee_pay_run_key]       INT            IDENTITY (1, 1) NOT NULL,
    [dim_company_key_pay_run_id_key] BIGINT         NULL,
    [dim_company_key]                INT            NOT NULL,
    [pay_run_id]                     INT            NULL,
    [pay_run_type]                   NVARCHAR (50)  NULL,
    [pay_run_status]                 NVARCHAR (20)  NULL,
    [pay_run_date]                   DATE           NULL,
    [pay_period_start_date]          DATE           NULL,
    [pay_period_end_date]            DATE           NULL,
    [company_code]                   INT            NULL,
    [DWHBatchId]                     INT            NOT NULL,
    [DWHEffectiveFrom]               DATETIME       NOT NULL,
    [DWHEffectiveTo]                 DATETIME       NOT NULL,
    [DWHDMLOperation]                CHAR (1)       NOT NULL,
    [DWHIsCurrent]                   BIT            NOT NULL,
    [DWHSourceSystem]                NVARCHAR (500) NOT NULL,
    CONSTRAINT [PK__edw_dim_employee_pay_run] PRIMARY KEY NONCLUSTERED ([dim_employee_pay_run_key] ASC)
);

