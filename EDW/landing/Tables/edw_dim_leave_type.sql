CREATE TABLE [landing].[edw_dim_leave_type] (
    [leave_type_id]           NVARCHAR (50) NULL,
    [leave_type_name]         NVARCHAR (50) NULL,
    [leave_type_group]        NVARCHAR (50) NULL,
    [leave_type_company_name] NVARCHAR (50) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_edw_dim_leave_type]
    ON [landing].[edw_dim_leave_type]([leave_type_id] ASC, [leave_type_company_name] ASC);

