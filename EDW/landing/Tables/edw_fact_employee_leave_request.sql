CREATE TABLE [landing].[edw_fact_employee_leave_request] (
    [leave_request_id]              NVARCHAR (36)  NULL,
    [employee_id]                   INT            NULL,
    [leave_request_type_id]         NVARCHAR (36)  NULL,
    [leave_request_start_date_time] DATETIME2 (7)  NULL,
    [leave_request_end_date_time]   DATETIME2 (7)  NULL,
    [leave_request_status]          NVARCHAR (255) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [fact_employee_leave_request]
    ON [landing].[edw_fact_employee_leave_request]([leave_request_id] ASC);

