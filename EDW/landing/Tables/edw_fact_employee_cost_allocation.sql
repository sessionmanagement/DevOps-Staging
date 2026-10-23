CREATE TABLE [landing].[edw_fact_employee_cost_allocation] (
    [employee_id]                  INT            NULL,
    [intellihr_business_unit_id]   NVARCHAR (36)  NULL,
    [intellihr_business_unit_code] NVARCHAR (200) NULL,
    [intellihr_business_unit_name] NVARCHAR (100) NULL,
    [datapay_cost_center_code]     VARCHAR (200)  NULL,
    [datapay_cost_center_name]     VARCHAR (200)  NULL,
    [cost_allocation_percentage]   FLOAT (53)     NULL,
    [person_is_supervisor]         INT            NULL,
    [job_title]                    NVARCHAR (100) NULL,
    [company_id]                   NVARCHAR (36)  NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [fact_employee_cost_allocation]
    ON [landing].[edw_fact_employee_cost_allocation]([employee_id] ASC, [datapay_cost_center_code] ASC, [company_id] ASC);

