CREATE TABLE [landing].[edw_fact_client_activity_breakdown] (
    [company_key]                                INT            NULL,
    [client_activity_breakdown_id]               INT            NULL,
    [client_activity_id]                         INT            NULL,
    [client_parent_activity_id]                  INT            NULL,
    [client_referral_id]                         INT            NULL,
    [client_id]                                  INT            NULL,
    [client_activity_user_id]                    INT            NULL,
    [user_employee_number]                       INT            NULL,
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
    [client_activity_description]                NVARCHAR (10)  NULL
);














GO
CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_edw_fact_client_activity_breakdown]
    ON [landing].[edw_fact_client_activity_breakdown]([client_activity_breakdown_id] ASC, [client_activity_id] ASC, [client_referral_id] ASC, [client_id] ASC, [client_activity_breakdown_type_id] ASC, [company_key] ASC, [client_activity_user_id] ASC);

