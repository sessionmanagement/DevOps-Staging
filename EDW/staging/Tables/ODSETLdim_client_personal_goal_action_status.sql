CREATE TABLE [staging].[ODSETLdim_client_personal_goal_action_status] (
    [personal_goal_action_status_id]                    INT            NULL,
    [company_id]                                        INT            NOT NULL,
    [dim_client_personal_goal_action_status_unique_key] NVARCHAR (100) NOT NULL,
    [personal_goal_action_status_code]                  NVARCHAR (30)  NULL,
    [personal_goal_action_status_text]                  NVARCHAR (50)  NULL,
    [personal_goal_action_status_is_completed_status]   BIT            NULL,
    [personal_goal_action_status_is_cancelled_status]   BIT            NULL,
    [personal_goal_action_status_sort_index]            INT            NULL
);



