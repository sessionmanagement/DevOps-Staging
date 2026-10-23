CREATE TABLE [edw].[dim_employee_pay_component] (
    [dim_employee_pay_component_key]    INT            IDENTITY (1, 1) NOT NULL,
    [dim_company_key_pay_component_key] NVARCHAR (100) NULL,
    [dim_company_key]                   INT            NOT NULL,
    [pay_component_code]                NVARCHAR (50)  NULL,
    [pay_component_name]                NVARCHAR (100) NULL,
    [pay_component_category]            NVARCHAR (50)  NULL,
    [company_code]                      INT            NULL,
    [DWHBatchId]                        INT            NOT NULL,
    [DWHEffectiveFrom]                  DATETIME       NOT NULL,
    [DWHEffectiveTo]                    DATETIME       NOT NULL,
    [DWHDMLOperation]                   CHAR (1)       NOT NULL,
    [DWHIsCurrent]                      BIT            NOT NULL,
    [DWHSourceSystem]                   NVARCHAR (500) NOT NULL,
    CONSTRAINT [PK__edw_dim_employee_pay_component] PRIMARY KEY NONCLUSTERED ([dim_employee_pay_component_key] ASC)
);

