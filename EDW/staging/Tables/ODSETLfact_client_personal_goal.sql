CREATE TABLE [staging].[ODSETLfact_client_personal_goal] (
    [company_id]                                        INT            NOT NULL,
    [fact_client_personal_goal_unique_key]              NVARCHAR (100) NOT NULL,
    [client_personal_goal_id]                           INT            NULL,
    [client_personal_goal_action_id]                    INT            NULL,
    [client_referral_id]                                INT            NULL,
    [client_id]                                         INT            NULL,
    [client_user_id]                                    INT            NULL,
    [client_user_employee_number]                       NVARCHAR (50)  NULL,
    [client_personal_plan_id]                           INT            NULL,
    [client_old_personal_goal_id]                       INT            NULL,
    [client_personal_plan_goal]                         NVARCHAR (200) NULL,
    [client_personal_goal_title]                        NVARCHAR (200) NULL,
    [client_personal_goal_status_id]                    INT            NULL,
    [client_personal_goal_action_description]           NVARCHAR (MAX) NULL,
    [client_personal_goal_action_status_id]             INT            NULL,
    [client_personal_goal_created_date_key]             INT            NULL,
    [client_personal_plan_start_date_key]               INT            NULL,
    [client_personal_plan_end_date_key]                 INT            NULL,
    [client_personal_goal_start_date_key]               INT            NULL,
    [client_personal_goal_due_date_key]                 INT            NULL,
    [client_personal_goal_action_due_date_key]          INT            NULL,
    [client_personal_goal_action_completed_date_key]    INT            NULL,
    [client_personal_goal_close_completed_date_key]     INT            NULL,
    [client_personal_goal_close_not_completed_date_key] INT            NULL,
    [client_personal_goal_close_date_key]               INT            NULL,
    [client_personal_goal_completed_status]             INT            NULL,
    [client_personal_goal_category]                     NVARCHAR (200) NULL,
    [client_personal_goal_category_description]         NVARCHAR (200) NULL,
    [goal_created_user_id]                              INT            NULL,
    [client_personal_goal_action_created_date_key]      INT            NULL,
    [goal_action_created_user_id]                       INT            NULL,
    [client_personal_goal_category_id]                  INT            NULL
);







