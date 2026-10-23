CREATE TABLE [landing].[edw_dim_client_personal_goal_status] (
    [company_key]                     INT            NULL,
    [personal_goal_status_type_id]    INT            NULL,
    [personal_goal_status_type_value] NVARCHAR (200) NULL,
    [personal_goal_status_type_text]  NVARCHAR (200) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_edw_dim_client_personal_goal_status]
    ON [landing].[edw_dim_client_personal_goal_status]([personal_goal_status_type_id] ASC, [company_key] ASC);

