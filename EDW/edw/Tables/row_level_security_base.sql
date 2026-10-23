CREATE TABLE [edw].[row_level_security_base] (
    [row_level_security_id]          BIGINT        IDENTITY (1, 1) NOT NULL,
    [RLS_Type]                       VARCHAR (30)  NOT NULL,
    [dim_employee_key]               INT           NULL,
    [employee_id]                    INT           NULL,
    [employee_primary_email_address] VARCHAR (200) NULL,
    [employee_job_name]              VARCHAR (80)  NULL,
    [service_name]                   VARCHAR (50)  NULL,
    [dim_service_key]                INT           NULL,
    [service_id]                     INT           NULL,
    [service_code]                   VARCHAR (30)  NOT NULL,
    [department_name]                VARCHAR (50)  NOT NULL,
    [district_name]                  VARCHAR (50)  NOT NULL,
    [region_name]                    VARCHAR (50)  NOT NULL,
    [company]                        VARCHAR (50)  NOT NULL,
    [client_team_id]                 INT           NULL,
    [client_team_name]               VARCHAR (50)  NULL,
    CONSTRAINT [PK_row_level_security_base] PRIMARY KEY CLUSTERED ([row_level_security_id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_row_level_security_base_employee_id]
    ON [edw].[row_level_security_base]([employee_id] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_row_level_security_base_service_id]
    ON [edw].[row_level_security_base]([service_id] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_row_level_security_base_RLS_type]
    ON [edw].[row_level_security_base]([RLS_Type] ASC);

