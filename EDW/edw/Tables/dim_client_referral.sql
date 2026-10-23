CREATE TABLE [edw].[dim_client_referral] (
    [dim_client_referral_key]               INT            IDENTITY (100000, 1) NOT NULL,
    [client_referral_id]                    INT            NOT NULL,
    [dim_client_referral_unique_key]        NVARCHAR (200) NULL,
    [company_id]                            INT            NOT NULL,
    [client_id]                             INT            NOT NULL,
    [client_team_id]                        INT            NULL,
    [client_referral_type]                  VARCHAR (32)   NULL,
    [client_referrer_name]                  NVARCHAR (50)  NULL,
    [client_referral_source_id]             INT            NULL,
    [client_referral_discharge_reason]      NVARCHAR (300) NULL,
    [client_referral_accepted_reason]       NVARCHAR (300) NULL,
    [client_referral_waitlist_reason]       NVARCHAR (300) NULL,
    [client_referral_declined_reason]       NVARCHAR (300) NULL,
    [client_referral_pending_reason]        NVARCHAR (300) NULL,
    [client_status_is_active]               VARCHAR (10)   NULL,
    [client_referral_status]                NVARCHAR (10)  NULL,
    [client_referral_discharge_reason_code] NVARCHAR (50)  NULL,
    [client_referral_accepted_reason_code]  NVARCHAR (50)  NULL,
    [client_referral_waitlist_reason_code]  NVARCHAR (50)  NULL,
    [client_referral_declined_reason_code]  NVARCHAR (50)  NULL,
    [client_referral_pending_reason_code]   NVARCHAR (300)  NULL,
    [client_referrer_code]                  NVARCHAR (20)  NULL,
    [client_referral_discharge_comment]     NVARCHAR (MAX) NULL,
    [client_referral_accepted_comment]      NVARCHAR (MAX) NULL,
    [client_referral_waitlist_comment]      NVARCHAR (MAX) NULL,
    [client_referral_declined_comment]      NVARCHAR (MAX) NULL,
    [client_referral_pending_comment]       NVARCHAR (MAX) NULL,
    [DWHSourceSystem]                       NVARCHAR (500) NOT NULL,
    [DWHBatchId]                            INT            NOT NULL,
    [DWHDMLOperation]                       CHAR (1)       NOT NULL,
    [DWHModifiedOn]                         DATETIME       NOT NULL,
    [DWHCreatedAt]                          DATETIME       NOT NULL,
    CONSTRAINT [PK_EDW_dim_client_referral] PRIMARY KEY NONCLUSTERED ([dim_client_referral_key] ASC)
);
















GO
CREATE NONCLUSTERED INDEX [idx1_dim_client_referral]
    ON [edw].[dim_client_referral]([client_referral_id] ASC, [company_id] ASC, [client_id] ASC)
    INCLUDE([dim_client_referral_key]);

