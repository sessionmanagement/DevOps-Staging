CREATE TABLE [edw].[row_level_security_general] (
    [row_level_security_id]        INT              IDENTITY (1, 1) NOT NULL,
    [RLS_type]                     NVARCHAR (15)    NOT NULL,
    [dim_employee_key]             INT              NOT NULL,
    [employee_id]                  INT              NOT NULL,
    [email]                        NVARCHAR (80)    NULL,
    [dim_company_key]              INT              NULL,
    [dim_service_key]              INT              NULL,
    [service_id]                   INT              NULL,
    [dim_property_key]             INT              NULL,
    [property_id]                  UNIQUEIDENTIFIER NULL,
    [dim_property_tenancy_key]     INT              NULL,
    [property_tenancy_id]          UNIQUEIDENTIFIER NULL,
    [dim_client_team_key]          INT              NULL,
    [client_team_id]               INT              NULL,
    [employee_level_for_exclusion] INT              NULL,
    [mapped_employee_id]           INT              NULL,
    [mapped_employee_name]         NVARCHAR (80)    NULL,
    [mapped_employee_job_title]    NVARCHAR (80)    NULL,
    CONSTRAINT [PK_row_level_security_general] PRIMARY KEY CLUSTERED ([row_level_security_id] ASC)
);






GO
CREATE NONCLUSTERED INDEX [IX_row_level_security_general_type]
    ON [edw].[row_level_security_general]([RLS_type] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_row_level_security_general_email]
    ON [edw].[row_level_security_general]([email] ASC);

