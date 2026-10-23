CREATE TABLE [landing].[edw_dim_employee_pay_component] (
    [pay_component_code]     NVARCHAR (50)  NULL,
    [pay_component_name]     NVARCHAR (100) NULL,
    [pay_component_category] NVARCHAR (50)  NULL,
    [company_code]           INT            NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [dim_employee_pay_component]
    ON [landing].[edw_dim_employee_pay_component]([pay_component_code] ASC, [company_code] ASC);

