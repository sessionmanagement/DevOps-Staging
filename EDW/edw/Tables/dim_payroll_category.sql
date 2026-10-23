CREATE TABLE [edw].[dim_payroll_category] (
    [dim_payroll_category_key]              INT            IDENTITY (1, 1) NOT NULL,
    [payroll_category_id]                   NVARCHAR (36)  NULL,
    [payroll_category_name]                 VARCHAR (50)   NULL,
    [payroll_category_short_name]           VARCHAR (50)   NULL,
    [payroll_category_add_to_duration_flag] INT            NULL,
    [payroll_category_hours_worked_flag]    INT            NULL,
    [DWHBatchId]                            INT            NOT NULL,
    [DWHCreatedAt]                          DATETIME       NOT NULL,
    [DWHModifiedOn]                         DATETIME       NOT NULL,
    [DWHDMLOperation]                       CHAR (1)       NOT NULL,
    [DWHSourceSystem]                       NVARCHAR (500) NOT NULL,
    CONSTRAINT [PK__edw_dim_payroll_category] PRIMARY KEY NONCLUSTERED ([dim_payroll_category_key] ASC)
);



