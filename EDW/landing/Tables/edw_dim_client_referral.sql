CREATE TABLE [landing].[edw_dim_client_referral] (
    [company_key]                           INT            NULL,
    [client_referral_id]                    INT            NULL,
    [client_id]                             INT            NULL,
    [client_team_id]                        INT            NULL,
    [client_referral_type]                  VARCHAR (32)   NULL,
    [client_referrer_code]                  NVARCHAR (20)  NULL,
    [client_referrer_name]                  NVARCHAR (50)  NULL,
    [source_referral_id]                    INT            NULL,
    [client_referral_discharge_reason]      NVARCHAR (300) NULL,
    [client_referral_accepted_reason]       NVARCHAR (300) NULL,
    [client_referral_waitlist_reason]       NVARCHAR (300) NULL,
    [client_referral_declined_reason]       NVARCHAR (300) NULL,
    [client_referral_pending_reason]        NVARCHAR (300) NULL,
    [client_referral_discharge_reason_code] NVARCHAR (50)  NULL,
    [client_referral_accepted_reason_code]  NVARCHAR (50)  NULL,
    [client_referral_waitlist_reason_code]  NVARCHAR (50)  NULL,
    [client_referral_declined_reason_code]  NVARCHAR (50)  NULL,
    [client_referral_pending_reason_code]   NVARCHAR (300)  NULL,
    [client_status_is_active]               VARCHAR (10)   NULL,
    [client_referral_status]                NVARCHAR (10)  NULL,
    [client_referral_discharge_comment]     NVARCHAR (MAX) NULL,
    [client_referral_accepted_comment]      NVARCHAR (MAX) NULL,
    [client_referral_waitlist_comment]      NVARCHAR (MAX) NULL,
    [client_referral_declined_comment]      NVARCHAR (MAX) NULL,
    [client_referral_pending_comment]       NVARCHAR (MAX) NULL
);














GO
CREATE UNIQUE NONCLUSTERED INDEX [BK_Landing_edw_dim_client_referral]
    ON [landing].[edw_dim_client_referral]([client_referral_id] ASC, [client_id] ASC, [company_key] ASC);



