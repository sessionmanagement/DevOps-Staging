CREATE TABLE [landing].[row_level_security_recordbase] (
    [employee_number]       INT            NULL,
    [employee_display_name] NVARCHAR (100) NULL,
    [employee_email]        NVARCHAR (300) NULL,
    [job_title]             NVARCHAR (100) NULL,
    [is_supervisor]         INT            NULL,
    [recordbase_team_id]    INT            NULL,
    [recordbase_team_name]  NVARCHAR (100) NULL,
    [UserID]                INT            NULL,
    [UserUsername]          NVARCHAR (300) NULL,
    [UserFirstName]         NVARCHAR (50)  NULL,
    [UserLastName]          NVARCHAR (50)  NULL,
    [UserEmailAddress]      NVARCHAR (300) NULL,
    [ReportsToUserID]       INT            NULL,
    [UserEmployeeNumber]    NVARCHAR (50)  NULL,
    [TeamID]                INT            NULL,
    [TeamName]              NVARCHAR (100) NULL,
    [TeamCode]              NVARCHAR (10)  NULL,
    [company_name]          VARCHAR (29)   NULL
);

