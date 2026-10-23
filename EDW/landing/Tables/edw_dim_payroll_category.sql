CREATE TABLE [landing].[edw_dim_payroll_category] (
    [payroll_category_id]                   NVARCHAR (36) NULL,
    [payroll_category_name]                 VARCHAR (50)  NULL,
    [payroll_category_short_name]           VARCHAR (50)  NULL,
    [payroll_category_add_to_duration_flag] INT           NULL,
    [payroll_category_hours_worked_flag]    INT           NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_edw_dim_payroll_category]
    ON [landing].[edw_dim_payroll_category]([payroll_category_id] ASC);

