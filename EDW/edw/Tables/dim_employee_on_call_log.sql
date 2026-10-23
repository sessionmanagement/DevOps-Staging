CREATE TABLE [edw].[dim_employee_on_call_log] (
    [dim_employee_on_call_log_key] INT             IDENTITY (1, 1) NOT NULL,
    [on_call_id]                   INT             NULL,
    [on_call_title]                NVARCHAR (100)  NULL,
    [event_name]                   NVARCHAR (100)  NULL,
    [call_received_from]           NVARCHAR (100)  NULL,
    [issue_description]            NVARCHAR (3000) NULL,
    [outcome]                      NVARCHAR (3000) NULL,
    [escalation_comments]          NVARCHAR (600)  NULL,
    [DWHBatchId]                   INT             NOT NULL,
    [DWHCreatedAt]                 DATETIME        NOT NULL,
    [DWHModifiedOn]                DATETIME        NOT NULL,
    [DWHDMLOperation]              CHAR (1)        NOT NULL,
    [DWHSourceSystem]              NVARCHAR (100)  NOT NULL,
    CONSTRAINT [PK__edw_dim_employee_on_call_log] PRIMARY KEY NONCLUSTERED ([dim_employee_on_call_log_key] ASC)
);

