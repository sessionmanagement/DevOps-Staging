CREATE TABLE [staging].[ODSETLfact_client_address_history] (
    [client_id]                              INT            NOT NULL,
    [client_address_id]                      INT            NOT NULL,
    [company_id]                             INT            NOT NULL,
    [fact_client_address_history_unique_key] NVARCHAR (200) NOT NULL,
    [client_address_name]                    NVARCHAR (50)  NULL,
    [client_address_line1]                   NVARCHAR (200) NULL,
    [client_address_line2]                   NVARCHAR (200) NULL,
    [client_address_line3]                   NVARCHAR (200) NULL,
    [client_address_suburb]                  NVARCHAR (100) NULL,
    [client_address_town_or_city]            NVARCHAR (50)  NULL,
    [client_address_post_code]               NVARCHAR (50)  NULL,
    [client_address_created_date_key]        INT            NULL,
    [client_address_start_date_key]          INT            NULL,
    [client_address_end_date_key]            INT            NULL,
    [client_address_is_postal_flag]          INT            NULL,
    [client_address_is_primary_flag]         INT            NULL
);






GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_fact_client_address_history]
    ON [staging].[ODSETLfact_client_address_history]([fact_client_address_history_unique_key] ASC);




GO



GO



GO



GO



GO
EXECUTE sp_addextendedproperty @name = N'sys_data_classification_recommendation_disabled', @value = 1, @level0type = N'SCHEMA', @level0name = N'staging', @level1type = N'TABLE', @level1name = N'ODSETLfact_client_address_history', @level2type = N'COLUMN', @level2name = N'client_address_post_code';


GO
EXECUTE sp_addextendedproperty @name = N'sys_data_classification_recommendation_disabled', @value = 1, @level0type = N'SCHEMA', @level0name = N'staging', @level1type = N'TABLE', @level1name = N'ODSETLfact_client_address_history', @level2type = N'COLUMN', @level2name = N'client_address_town_or_city';


GO
EXECUTE sp_addextendedproperty @name = N'sys_data_classification_recommendation_disabled', @value = 1, @level0type = N'SCHEMA', @level0name = N'staging', @level1type = N'TABLE', @level1name = N'ODSETLfact_client_address_history', @level2type = N'COLUMN', @level2name = N'client_address_suburb';


GO
EXECUTE sp_addextendedproperty @name = N'sys_data_classification_recommendation_disabled', @value = 1, @level0type = N'SCHEMA', @level0name = N'staging', @level1type = N'TABLE', @level1name = N'ODSETLfact_client_address_history', @level2type = N'COLUMN', @level2name = N'client_address_line3';


GO
EXECUTE sp_addextendedproperty @name = N'sys_data_classification_recommendation_disabled', @value = 1, @level0type = N'SCHEMA', @level0name = N'staging', @level1type = N'TABLE', @level1name = N'ODSETLfact_client_address_history', @level2type = N'COLUMN', @level2name = N'client_address_line2';


GO
EXECUTE sp_addextendedproperty @name = N'sys_data_classification_recommendation_disabled', @value = 1, @level0type = N'SCHEMA', @level0name = N'staging', @level1type = N'TABLE', @level1name = N'ODSETLfact_client_address_history', @level2type = N'COLUMN', @level2name = N'client_address_line1';


GO
EXECUTE sp_addextendedproperty @name = N'sys_data_classification_recommendation_disabled', @value = 1, @level0type = N'SCHEMA', @level0name = N'staging', @level1type = N'TABLE', @level1name = N'ODSETLfact_client_address_history', @level2type = N'COLUMN', @level2name = N'client_address_name';


GO
EXECUTE sp_addextendedproperty @name = N'sys_data_classification_recommendation_disabled', @value = 1, @level0type = N'SCHEMA', @level0name = N'staging', @level1type = N'TABLE', @level1name = N'ODSETLfact_client_address_history', @level2type = N'COLUMN', @level2name = N'client_address_start_date_key';


GO
EXECUTE sp_addextendedproperty @name = N'sys_data_classification_recommendation_disabled', @value = 1, @level0type = N'SCHEMA', @level0name = N'staging', @level1type = N'TABLE', @level1name = N'ODSETLfact_client_address_history', @level2type = N'COLUMN', @level2name = N'client_address_is_postal_flag';


GO
EXECUTE sp_addextendedproperty @name = N'sys_data_classification_recommendation_disabled', @value = 1, @level0type = N'SCHEMA', @level0name = N'staging', @level1type = N'TABLE', @level1name = N'ODSETLfact_client_address_history', @level2type = N'COLUMN', @level2name = N'client_address_end_date_key';


GO
EXECUTE sp_addextendedproperty @name = N'sys_data_classification_recommendation_disabled', @value = 1, @level0type = N'SCHEMA', @level0name = N'staging', @level1type = N'TABLE', @level1name = N'ODSETLfact_client_address_history', @level2type = N'COLUMN', @level2name = N'client_address_created_date_key';

