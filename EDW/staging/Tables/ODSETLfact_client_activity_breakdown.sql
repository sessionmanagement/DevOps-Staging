CREATE TABLE [staging].[ODSETLfact_client_activity_breakdown] (
    [client_activity_breakdown_id]               INT            NULL,
    [client_activity_id]                         INT            NOT NULL,
    [fact_client_activity_breakdown_unique_key]  NVARCHAR (100) NOT NULL,
    [company_id]                                 INT            NOT NULL,
    [client_parent_activity_id]                  INT            NULL,
    [client_referral_id]                         INT            NULL,
    [client_id]                                  INT            NULL,
    [client_activity_user_id]                    INT            NULL,
    [client_team_id]                             INT            NULL,
    [client_activity_breakdown_type_id]          INT            NULL,
    [client_activity_type_code]                  NVARCHAR (20)  NULL,
    [client_activity_type_name]                  NVARCHAR (50)  NULL,
    [client_activity_type_description]           NVARCHAR (350) NULL,
    [client_activity_classification_code]        NVARCHAR (20)  NULL,
    [client_activity_classification_name]        NVARCHAR (50)  NULL,
    [client_activity_classification_description] NVARCHAR (350) NULL,
    [client_activity_created_date]               DATETIME       NULL,
    [client_activity_start_date]                 DATETIME       NULL,
    [client_activity_end_date]                   DATETIME       NULL,
    [client_activity_breakdown_created_date]     DATETIME       NULL,
    [client_activity_duration]                   INT            NULL,
    [client_activity_whanau_involvement]         INT            NULL,
    [client_group_activity_id]                   INT            NULL,
    [client_activity_subject]                    NVARCHAR (350) NULL,
    [client_activity_description]                NVARCHAR (10)  NULL,
    [user_employee_number]                       NVARCHAR (50)  NULL
);














GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_fact_activity_breakdown]
    ON [staging].[ODSETLfact_client_activity_breakdown]([fact_client_activity_breakdown_unique_key] ASC);

