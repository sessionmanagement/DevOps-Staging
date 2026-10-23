CREATE TABLE [staging].[ODSETLdim_client_referral_service_level] (
    [dim_client_referral_service_level_key] INT            IDENTITY (1, 1) NOT NULL,
    [dim_client_key]                        INT            NULL,
    [dim_client_referral_key]               INT            NULL,
    [client_referral_service_level_id]      INT            NULL,
    [company_id]                            INT            NULL,
    [client_id]                             INT            NULL,
    [client_referral_id]                    INT            NULL,
    [service_level_code]                    NVARCHAR (50)  NULL,
    [service_level]                         NVARCHAR (200) NULL,
    [effective_date]                        DATE           NULL,
    [service_level_group]                   NVARCHAR (50)  NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLdim_client_referral_service_level] PRIMARY KEY NONCLUSTERED ([dim_client_referral_service_level_key] ASC)
);

