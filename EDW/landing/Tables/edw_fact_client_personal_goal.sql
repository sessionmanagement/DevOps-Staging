CREATE TABLE [landing].[edw_fact_client_personal_goal] (
    [company_key]                            INT            NULL,
    [personal_goal_id]                       INT            NULL,
    [personal_goal_action_id]                INT            NULL,
    [referral_id]                            INT            NULL,
    [client_id]                              INT            NULL,
    [user_id]                                INT            NULL,
    [user_employee_number]                   NVARCHAR (50)  NULL,
    [personal_plan_id]                       INT            NULL,
    [old_personal_goal_id]                   INT            NULL,
    [personal_plan_goal]                     NVARCHAR (200) NULL,
    [personal_goal_title]                    NVARCHAR (200) NULL,
    [personal_goal_status_id]                INT            NULL,
    [personal_goal_action_description]       NVARCHAR (MAX) NULL,
    [personal_goal_action_status_id]         INT            NULL,
    [personal_goal_created_date]             DATETIME       NULL,
    [personal_plan_start_date]               SMALLDATETIME  NULL,
    [personal_plan_end_date]                 SMALLDATETIME  NULL,
    [personal_goal_start_date]               DATETIME       NULL,
    [personal_goal_due_date]                 DATETIME       NULL,
    [personal_goal_action_due_date]          DATETIME       NULL,
    [personal_goal_action_completed_date]    DATETIME       NULL,
    [personal_goal_close_completed_date]     DATETIME       NULL,
    [personal_goal_close_not_completed_date] DATETIME       NULL,
    [personal_goal_close_date]               DATETIME       NULL,
    [personal_goal_completed_status]         INT            NULL,
    [personal_goal_category]                 NVARCHAR (200) NULL,
    [personal_goal_category_description]     NVARCHAR (200) NULL,
    [goal_created_user_id]                   INT            NULL,
    [personal_goal_action_created_date]      DATETIME       NULL,
    [goal_action_created_user_id]            INT            NULL,
    [personal_goal_category_id]              INT            NULL
);






GO
CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_edw_fact_client_personal_goal]
    ON [landing].[edw_fact_client_personal_goal]([personal_goal_id] ASC, [personal_goal_action_id] ASC, [referral_id] ASC, [client_id] ASC, [company_key] ASC);

