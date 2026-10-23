CREATE TABLE [staging].[ODSETLfact_client_referral_goal] (
    [company_id]                                INT            NOT NULL,
    [fact_client_referral_goal_unique_key]      NVARCHAR (100) NOT NULL,
    [client_referral_goal_id]                   INT            NOT NULL,
    [client_id]                                 INT            NULL,
    [client_referral_goal_title]                NVARCHAR (200) NULL,
    [client_referral_goal_start_date_key]       INT            NULL,
    [client_referral_goal_end_date_key]         INT            NULL,
    [client_referral_goal_created_date_key]     INT            NULL,
    [client_referral_goal_created_user_id]      INT            NULL,
    [client_referral_goal_review_cycle]         INT            NULL,
    [client_referral_goal_next_review_date_key] INT            NULL,
    [client_referral_id]                        INT            NULL
);







