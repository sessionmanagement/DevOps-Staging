CREATE TABLE [edw].[dim_leave_type] (
    [dim_leave_type_key]      INT            IDENTITY (1, 1) NOT NULL,
    [leave_type_id]           NVARCHAR (50)  NULL,
    [leave_type_name]         NVARCHAR (50)  NULL,
    [leave_type_group]        NVARCHAR (50)  NULL,
    [leave_type_company_name] NVARCHAR (50)  NULL,
    [DWHBatchId]              INT            NOT NULL,
    [DWHCreatedAt]            DATETIME       NOT NULL,
    [DWHModifiedOn]           DATETIME       NOT NULL,
    [DWHDMLOperation]         CHAR (1)       NOT NULL,
    [DWHSourceSystem]         NVARCHAR (500) NOT NULL,
    CONSTRAINT [PK__edw_dim_leave_type] PRIMARY KEY NONCLUSTERED ([dim_leave_type_key] ASC)
);



