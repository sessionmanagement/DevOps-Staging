CREATE TABLE [landing].[edw_dim_client_personal_goal_action_status] (
    [company_key]                                     INT           NULL,
    [personal_goal_action_status_id]                  INT           NULL,
    [personal_goal_action_status_code]                NVARCHAR (30) NULL,
    [personal_goal_action_status_text]                NVARCHAR (50) NULL,
    [personal_goal_action_status_is_completed_status] BIT           NULL,
    [personal_goal_action_status_is_cancelled_status] BIT           NULL,
    [personal_goal_action_status_sort_index]          INT           NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_edw_dim_client_personal_goal_action_status]
    ON [landing].[edw_dim_client_personal_goal_action_status]([personal_goal_action_status_id] ASC, [company_key] ASC);

