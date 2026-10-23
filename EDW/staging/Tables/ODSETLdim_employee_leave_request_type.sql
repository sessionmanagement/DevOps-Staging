CREATE TABLE [staging].[ODSETLdim_employee_leave_request_type] (
    [ODSdim_employee_leave_request_typeID] INT            IDENTITY (1, 1) NOT NULL,
    [leave_request_type_id]                NVARCHAR (36)  NULL,
    [leave_request_type_code]              NVARCHAR (255) NULL,
    [leave_request_type]                   NVARCHAR (255) NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLdim_employee_leave_request_type] PRIMARY KEY NONCLUSTERED ([ODSdim_employee_leave_request_typeID] ASC)
);

