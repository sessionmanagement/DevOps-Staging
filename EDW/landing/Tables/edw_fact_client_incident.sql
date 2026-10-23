CREATE TABLE [landing].[edw_fact_client_incident] (
    [company_key]                             INT            NULL,
    [incident_id]                             INT            NULL,
    [incident_date]                           DATETIME       NULL,
    [incident_created_date]                   DATETIME       NULL,
    [current_owner_user_id]                   NVARCHAR (50)  NULL,
    [current_investigator_user_id]            NVARCHAR (50)  NULL,
    [current_reporter_user_id]                NVARCHAR (50)  NULL,
    [incident_created_user_id]                NVARCHAR (50)  NULL,
    [current_owner_user_email_address]        NVARCHAR (300) NULL,
    [current_investigator_user_email_address] NVARCHAR (300) NULL,
    [current_reporter_user_email_address]     NVARCHAR (300) NULL,
    [incident_created_user_email_address]     NVARCHAR (300) NULL,
    [current_incident_status_type_id]         INT            NULL,
    [current_incident_status_created_date]    DATETIME       NULL,
    [team_id]                                 INT            NULL,
    [originator_user_id]                      NVARCHAR (50)  NULL,
    [originator_user_email_address]           NVARCHAR (300) NULL,
    [current_incident_severity_id]            INT            NULL,
    [incident_category_type_id]               INT            NULL
);




GO
