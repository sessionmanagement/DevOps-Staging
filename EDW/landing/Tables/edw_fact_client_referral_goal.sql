CREATE TABLE [landing].[edw_fact_client_referral_goal] (
    [company_key]                    INT            NULL,
    [referral_goal_id]               INT            NULL,
    [client_id]                      INT            NULL,
    [referral_goal_title]            NVARCHAR (200) NULL,
    [referral_goal_start_date]       SMALLDATETIME  NULL,
    [referral_goal_end_date]         SMALLDATETIME  NULL,
    [referral_goal_created_date]     DATETIME       NULL,
    [referral_goal_created_user_id]  INT            NULL,
    [referral_goal_next_review_date] SMALLDATETIME  NULL,
    [referral_goal_review_cycle]     INT            NULL,
    [client_referral_id]             INT            NULL
);






GO
CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_edw_fact_client_referral_goal]
    ON [landing].[edw_fact_client_referral_goal]([referral_goal_id] ASC, [company_key] ASC);

