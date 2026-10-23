CREATE TABLE [edw].[dim_client_referral_service_level] (
    [dim_client_referral_service_level_key] INT            IDENTITY (1, 1) NOT NULL,
    [dim_client_key]                        INT            NULL,
    [dim_client_referral_key]               INT            NULL,
    [client_referral_service_level_id]      INT            NULL,
    [company_id]                            INT            NOT NULL,
    [client_id]                             INT            NULL,
    [client_referral_id]                    INT            NULL,
    [service_level_code]                    NVARCHAR (50)  NULL,
    [service_level]                         NVARCHAR (200) NULL,
    [effective_date]                        DATE           NULL,
    [service_level_group]                   NVARCHAR (50)  NULL,
    [DWHBatchId]                            INT            NOT NULL,
    [DWHEffectiveFrom]                      DATETIME       NOT NULL,
    [DWHEffectiveTo]                        DATETIME       NOT NULL,
    [DWHDMLOperationField]                  CHAR (1)       NOT NULL,
    [DWHIsCurrent]                          BIT            NOT NULL,
    [DWHSourceSystem]                       NVARCHAR (500) NOT NULL,
    CONSTRAINT [PK__edw_dim_client_referral_service_level] PRIMARY KEY NONCLUSTERED ([dim_client_referral_service_level_key] ASC)
);

