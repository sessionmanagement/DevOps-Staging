CREATE TABLE [staging].[ODSETLdim_employee_pay_component] (
    [ODSdim_employee_pay_componentID]   INT            IDENTITY (1, 1) NOT NULL,
    [dim_company_key_pay_component_key] NVARCHAR (100) NULL,
    [dim_company_key]                   INT            NOT NULL,
    [pay_component_code]                NVARCHAR (50)  NULL,
    [pay_component_name]                NVARCHAR (100) NULL,
    [pay_component_category]            NVARCHAR (50)  NULL,
    [company_code]                      INT            NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLdim_employee_pay_component] PRIMARY KEY NONCLUSTERED ([ODSdim_employee_pay_componentID] ASC)
);

