CREATE TABLE [staging].[ODSETLfact_employee_leave_request] (
    [fact_employee_leave_request_key]     INT            IDENTITY (1, 1) NOT NULL,
    [dim_employee_key]                    INT            NOT NULL,
    [dim_employee_leave_request_type_key] INT            NOT NULL,
    [dim_leave_request_start_date_key]    INT            NULL,
    [dim_leave_request_end_date_key]      INT            NULL,
    [leave_request_id]                    NVARCHAR (36)  NULL,
    [employee_id]                         INT            NULL,
    [leave_request_type_id]               NVARCHAR (36)  NULL,
    [leave_request_start_date_time]       DATETIME2 (7)  NULL,
    [leave_request_end_date_time]         DATETIME2 (7)  NULL,
    [leave_request_status]                NVARCHAR (255) NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLfact_employee_leave_request] PRIMARY KEY NONCLUSTERED ([fact_employee_leave_request_key] ASC)
);

