CREATE TABLE [edw].[fact_client_referral_goal] (
    [fact_client_referral_goal_key]             INT            IDENTITY (100000, 1) NOT NULL,
    [fact_client_referral_goal_unique_key]      NVARCHAR (100) NOT NULL,
    [dim_company_key]                           INT            NOT NULL,
    [dim_client_key]                            INT            NOT NULL,
    [client_referral_goal_id]                   INT            NOT NULL,
    [client_id]                                 INT            NULL,
    [client_referral_goal_title]                NVARCHAR (200) NULL,
    [client_referral_goal_start_date_key]       INT            NULL,
    [client_referral_goal_end_date_key]         INT            NULL,
    [client_referral_goal_created_date_key]     INT            NULL,
    [client_referral_goal_created_user_id]      INT            NULL,
    [DWHSourceSystem]                           NVARCHAR (500) NOT NULL,
    [DWHBatchId]                                INT            NOT NULL,
    [DWHDMLOperation]                           CHAR (1)       NOT NULL,
    [DWHModifiedOn]                             DATETIME       NOT NULL,
    [DWHCreatedAt]                              DATETIME       NOT NULL,
    [client_referral_goal_review_cycle]         INT            NULL,
    [client_referral_goal_next_review_date_key] INT            NULL,
    [client_referral_id]                        INT            NULL,
    [dim_client_referral_key]                   INT            NULL,
    CONSTRAINT [PK_EDW_fact_client_referral_goal] PRIMARY KEY NONCLUSTERED ([fact_client_referral_goal_key] ASC)
);





