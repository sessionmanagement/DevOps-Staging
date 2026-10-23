CREATE TABLE [landing].[edw_dim_employee_leave_request_type] (
    [leave_request_type_id]   NVARCHAR (36)  NULL,
    [leave_request_type_code] NVARCHAR (255) NULL,
    [leave_request_type]      NVARCHAR (255) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [dim_employee_leave_request_type]
    ON [landing].[edw_dim_employee_leave_request_type]([leave_request_type_id] ASC);

