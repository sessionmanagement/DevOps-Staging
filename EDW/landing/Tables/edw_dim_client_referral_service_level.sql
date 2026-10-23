CREATE TABLE [landing].[edw_dim_client_referral_service_level] (
    [client_referral_service_level_id] INT            NOT NULL,
    [company_id]                       INT            NULL,
    [client_id]                        INT            NULL,
    [client_referral_id]               INT            NULL,
    [service_level_code]               NVARCHAR (50)  NULL,
    [service_level]                    NVARCHAR (200) NULL,
    [effective_date]                   DATE           NULL,
    [service_level_group]              NVARCHAR (50)  NULL,
    CONSTRAINT [PK_edw_dim_client_referral_service_level] PRIMARY KEY CLUSTERED ([client_referral_service_level_id] ASC)
);




GO
