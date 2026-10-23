CREATE TABLE [staging].[ODSETLdim_employee_on_call_log] (
    [ODSdim_employee_on_call_logID] INT             IDENTITY (1, 1) NOT NULL,
    [on_call_id]                    INT             NULL,
    [on_call_title]                 NVARCHAR (100)  NULL,
    [event_name]                    NVARCHAR (100)  NULL,
    [call_received_from]            NVARCHAR (100)  NULL,
    [issue_description]             NVARCHAR (3000) NULL,
    [outcome]                       NVARCHAR (3000) NULL,
    [escalation_comments]           NVARCHAR (600)  NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLdim_employee_on_call_log] PRIMARY KEY NONCLUSTERED ([ODSdim_employee_on_call_logID] ASC)
);

