CREATE TABLE [edw].[dim_client] (
    [dim_client_key]                         INT             IDENTITY (100000, 1) NOT NULL,
    [company_id]                             INT             NOT NULL,
    [dim_client_unique_key]                  NVARCHAR (200)  NULL,
    [client_id]                              INT             NOT NULL,
    [client_display_name]                    NVARCHAR (1000) NULL,
    [client_first_name]                      NVARCHAR (50)   NULL,
    [client_middle_name]                     NVARCHAR (50)   NULL,
    [client_last_name]                       NVARCHAR (50)   NULL,
    [client_preferred_name]                  NVARCHAR (50)   NULL,
    [client_nhi_number]                      NVARCHAR (50)   NULL,
    [client_created_date]                    INT             NOT NULL,
    [client_address_missing_flag]            VARCHAR (1)     NULL,
    [client_address_missing_flag_date]       DATETIME        NULL,
    [client_address_name]                    NVARCHAR (50)   NULL,
    [client_address_line1]                   NVARCHAR (200)  NULL,
    [client_address_line2]                   NVARCHAR (200)  NULL,
    [client_address_line3]                   NVARCHAR (200)  NULL,
    [client_address_suburb]                  NVARCHAR (100)  NULL,
    [client_address_town_or_city]            NVARCHAR (50)   NULL,
    [client_address_post_code]               NVARCHAR (50)   NULL,
    [client_contact_phone_missing_flag]      VARCHAR (1)     NULL,
    [client_contact_phone_missing_flag_date] DATETIME        NULL,
    [client_contact_home_phone]              VARCHAR (60)    NULL,
    [client_contact_work_phone]              VARCHAR (60)    NULL,
    [client_contact_mobile_phone]            VARCHAR (60)    NULL,
    [client_contact_fax]                     VARCHAR (60)    NULL,
    [client_contact_pager]                   VARCHAR (60)    NULL,
    [client_contact_other]                   VARCHAR (60)    NULL,
    [client_emergency_contact_phone]         NVARCHAR (50)   NULL,
    [client_email]                           VARCHAR (300)   NULL,
    [client_primary_iwi]                     NVARCHAR (200)  NULL,
    [client_primary_region]                  VARCHAR (72)    NULL,
    [client_primary_waka_iwi_unknown_flag]   NVARCHAR (200)  NULL,
    [client_primary_ethnicity]               NVARCHAR (200)  NULL,
    [client_secondary_iwi]                   NVARCHAR (200)  NULL,
    [client_secondary_region]                VARCHAR (72)    NULL,
    [client_secondary_waka_iwi_unknown_flag] NVARCHAR (200)  NULL,
    [client_secondary_ethnicity]             NVARCHAR (200)  NULL,
    [client_tertiary_iwi]                    NVARCHAR (200)  NULL,
    [client_tertiary_region]                 VARCHAR (72)    NULL,
    [client_tertiary_waka_iwi_unknown_flag]  NVARCHAR (200)  NULL,
    [client_tertiary_ethnicity]              NVARCHAR (200)  NULL,
    [client_maori_flag]                      INT             NULL,
    [client_pasifika_flag]                   INT             NULL,
    [client_ethnicity_group]                 VARCHAR (37)    NULL,
    [client_gender]                          NVARCHAR (200)  NULL,
    [client_date_of_birth]                   DATE            NULL,
    [client_date_of_death]                   DATE            NULL,
    [client_age_years]                       DECIMAL (18)    NULL,
    [client_smoking_status]                  NVARCHAR (200)  NULL,
    [client_smoking_cigarettes_per_day]      NVARCHAR (200)  NULL,
    [client_smoking_assessment_date]         INT             NULL,
    [client_legal_status_missing_flag]       INT             NULL,
    [client_legal_status]                    NVARCHAR (200)  NULL,
    [client_mental_health_condition]         NVARCHAR (200)  NULL,
    [client_physical_condition]              NVARCHAR (200)  NULL,
    [client_substance_condition]             NVARCHAR (200)  NULL,
    [client_smoking_status_missing_flag]     INT             NULL,
    [client_smoking_advice_flag]             INT             NULL,
    [client_smoking_cessation_referral_flag] INT             NULL,
    [client_primhd_review_missing_flag]      INT             NULL,
    [client_primhd_review_overdue_flag]      INT             NULL,
    [client_primhd_review_due_soon_flag]     INT             NULL,
    [client_primhd_review_current_flag]      INT             NULL,
    [client_gp_only_missing_flag]            INT             NULL,
    [client_gp_registration_missing_flag]    INT             NULL,
    [client_residency_status]                NVARCHAR (200)  NULL,
    [client_status_is_active]                VARCHAR (10)    NULL,
    [client_status_is_active_date]           DATETIME        NULL,
    [client_smoking_last_assessment_flag]    INT             NULL,
    [DWHSourceSystem]                        NVARCHAR (500)  NOT NULL,
    [DWHBatchId]                             INT             NOT NULL,
    [DWHDMLOperation]                        CHAR (5)        NOT NULL,
    [DWHEffectiveFrom]                       DATETIME        NOT NULL,
    [DWHEffectiveTo]                         DATETIME        NOT NULL,
    [DWHIsCurrent]                           INT             NOT NULL,
    [primary_ethnicity_id]                   INT             NULL,
    [secondary_ethnicity_id]                 INT             NULL,
    [tertiary_ethnicity_id]                  INT             NULL,
    [fourth_ethnicity_id]                    INT             NULL,
    [primary_iwi_id]                         INT             NULL,
    [secondary_iwi_id]                       INT             NULL,
    [tertiary_iwi_id]                        INT             NULL,
    [fourth_iwi_id]                          INT             NULL,
    [priority_ethnicity_id]                  INT             NULL,
    CONSTRAINT [PK_EDW_dim_client_UPD] PRIMARY KEY NONCLUSTERED ([dim_client_key] ASC)
);






GO
CREATE NONCLUSTERED INDEX [idx1_dim_client]
    ON [edw].[dim_client]([client_id] ASC, [company_id] ASC)
    INCLUDE([dim_client_key], [DWHEffectiveFrom], [DWHEffectiveTo], [DWHIsCurrent]);


GO
EXECUTE sp_addextendedproperty @name = N'sys_data_classification_recommendation_disabled', @value = 1, @level0type = N'SCHEMA', @level0name = N'edw', @level1type = N'TABLE', @level1name = N'dim_client', @level2type = N'COLUMN', @level2name = N'client_address_line2';


GO
EXECUTE sp_addextendedproperty @name = N'sys_data_classification_recommendation_disabled', @value = 1, @level0type = N'SCHEMA', @level0name = N'edw', @level1type = N'TABLE', @level1name = N'dim_client', @level2type = N'COLUMN', @level2name = N'client_address_line1';


GO
EXECUTE sp_addextendedproperty @name = N'sys_data_classification_recommendation_disabled', @value = 1, @level0type = N'SCHEMA', @level0name = N'edw', @level1type = N'TABLE', @level1name = N'dim_client', @level2type = N'COLUMN', @level2name = N'client_address_name';


GO
EXECUTE sp_addextendedproperty @name = N'sys_data_classification_recommendation_disabled', @value = 1, @level0type = N'SCHEMA', @level0name = N'edw', @level1type = N'TABLE', @level1name = N'dim_client', @level2type = N'COLUMN', @level2name = N'client_address_missing_flag_date';


GO
EXECUTE sp_addextendedproperty @name = N'sys_data_classification_recommendation_disabled', @value = 1, @level0type = N'SCHEMA', @level0name = N'edw', @level1type = N'TABLE', @level1name = N'dim_client', @level2type = N'COLUMN', @level2name = N'client_last_name';


GO
EXECUTE sp_addextendedproperty @name = N'sys_data_classification_recommendation_disabled', @value = 1, @level0type = N'SCHEMA', @level0name = N'edw', @level1type = N'TABLE', @level1name = N'dim_client', @level2type = N'COLUMN', @level2name = N'client_first_name';

