CREATE TABLE [staging].[ODSETLfact_employee_user_session] (
    [ODSfact_employee_user_sessionID] INT            IDENTITY (1, 1) NOT NULL,
    [dim_employee_key]                INT            NULL,
    [employee_session_id]             INT            NULL,
    [company_id]                      INT            NULL,
    [user_id]                         INT            NULL,
    [sign_on_date]                    DATETIME2 (7)  NULL,
    [IP_address]                      NVARCHAR (20)  NULL,
    [browser_name]                    NVARCHAR (30)  NULL,
    [browser_version]                 NVARCHAR (10)  NULL,
    [application_id]                  INT            NULL,
    [user_agent]                      NVARCHAR (350) NULL,
    [impersonator_id]                 INT            NULL,
    [identity_sign_on_session]        NVARCHAR (200) NULL,
    [employee_id]                     INT            NULL,
    [employee_email]                  NVARCHAR (100) NULL,
    [employee_role]                   VARCHAR (50)   NULL,
    [session_location]                VARCHAR (20)   NOT NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLfact_employee_user_session] PRIMARY KEY NONCLUSTERED ([ODSfact_employee_user_sessionID] ASC)
);

