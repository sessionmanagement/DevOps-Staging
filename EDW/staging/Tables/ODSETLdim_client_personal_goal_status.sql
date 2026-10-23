CREATE TABLE [staging].[ODSETLdim_client_personal_goal_status] (
    [personal_goal_status_type_id]               INT            NULL,
    [company_id]                                 INT            NOT NULL,
    [dim_client_personal_goal_status_unique_key] NVARCHAR (100) NOT NULL,
    [personal_goal_status_type_value]            NVARCHAR (200) NULL,
    [personal_goal_status_type_text]             NVARCHAR (200) NULL
);



