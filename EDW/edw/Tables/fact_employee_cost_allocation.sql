CREATE TABLE [edw].[fact_employee_cost_allocation] (
    [fact_employee_cost_allocation_key] INT            IDENTITY (1, 1) NOT NULL,
    [dim_employee_key]                  INT            NOT NULL,
    [dim_company_key]                   INT            NOT NULL,
    [dim_service_key]                   INT            NOT NULL,
    [dim_business_unit_hierarchy_key]   INT            NOT NULL,
    [employee_id]                       INT            NULL,
    [intellihr_business_unit_id]        NVARCHAR (36)  NULL,
    [intellihr_business_unit_code]      NVARCHAR (200) NULL,
    [intellihr_business_unit_name]      NVARCHAR (100) NULL,
    [datapay_cost_center_code]          VARCHAR (200)  NULL,
    [datapay_cost_center_name]          VARCHAR (200)  NULL,
    [cost_allocation_percentage]        FLOAT (53)     NULL,
    [job_title]                         NVARCHAR (100) NULL,
    [company_id]                        NVARCHAR (36)  NULL,
    [DWHBatchId]                        INT            NOT NULL,
    [DWHCreatedAt]                      DATETIME       NOT NULL,
    [DWHModifiedOn]                     DATETIME       NOT NULL,
    [DWHDMLOperation]                   CHAR (1)       NOT NULL,
    [DWHSourceSystem]                   NVARCHAR (500) NOT NULL,
    CONSTRAINT [PK__edw_fact_employee_cost_allocation] PRIMARY KEY NONCLUSTERED ([fact_employee_cost_allocation_key] ASC)
);

