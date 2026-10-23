CREATE TABLE [staging].[ODSETLdim_employee_hierarchy] (
    [dim_employee_key]                                   INT            NULL,
    [employee_id]                                        INT            NULL,
    [employee_primary_email_address]                     NVARCHAR (100) NULL,
    [employee_company_name]                              NVARCHAR (200) NULL,
    [employee_Business_unit_name]                        NVARCHAR (100) NULL,
    [employee_displayname]                               NVARCHAR (100) NULL,
    [employee_people_leader_employee_number_level_1]     INT            NULL,
    [employee_people_leader_email_level_1]               NVARCHAR (100) NULL,
    [employee_people_leader_business_unit_name_level_1]  NVARCHAR (100) NULL,
    [employee_people_leader_person_display_name_level_1] NVARCHAR (100) NULL,
    [employee_people_leader_role_name_level_1]           NVARCHAR (100) NULL,
    [employee_people_leader_employee_number_level_2]     INT            NULL,
    [employee_people_leader_email_level_2]               NVARCHAR (100) NULL,
    [employee_people_leader_business_unit_name_level_2]  NVARCHAR (100) NULL,
    [employee_people_leader_person_display_name_level_2] NVARCHAR (100) NULL,
    [employee_people_leader_role_name_level_2]           NVARCHAR (100) NULL,
    [employee_people_leader_employee_number_level_3]     INT            NULL,
    [employee_people_leader_email_level_3]               NVARCHAR (100) NULL,
    [employee_people_leader_business_unit_name_level_3]  NVARCHAR (100) NULL,
    [employee_people_leader_person_display_name_level_3] NVARCHAR (100) NULL,
    [employee_people_leader_role_name_level_3]           NVARCHAR (100) NULL,
    [employee_people_leader_employee_number_level_4]     INT            NULL,
    [employee_people_leader_email_level_4]               NVARCHAR (100) NULL,
    [employee_people_leader_business_unit_name_level_4]  NVARCHAR (100) NULL,
    [employee_people_leader_person_display_name_level_4] NVARCHAR (100) NULL,
    [employee_people_leader_role_name_level_4]           NVARCHAR (100) NULL,
    [employee_people_leader_employee_number_level_5]     INT            NULL,
    [employee_people_leader_email_level_5]               NVARCHAR (100) NULL,
    [employee_people_leader_business_unit_name_level_5]  NVARCHAR (100) NULL,
    [employee_people_leader_person_display_name_level_5] NVARCHAR (100) NULL,
    [employee_people_leader_role_name_level_5]           NVARCHAR (100) NULL,
    [employee_people_leader_employee_number_level_6]     INT            NULL,
    [employee_people_leader_email_level_6]               NVARCHAR (100) NULL,
    [employee_people_leader_business_unit_name_level_6]  NVARCHAR (100) NULL,
    [employee_people_leader_person_display_name_level_6] NVARCHAR (100) NULL,
    [employee_people_leader_role_name_level_6]           NVARCHAR (100) NULL,
    [employee_people_leader_employee_number_level_7]     INT            NULL,
    [employee_people_leader_email_level_7]               NVARCHAR (100) NULL,
    [employee_people_leader_business_unit_name_level_7]  NVARCHAR (100) NULL,
    [employee_people_leader_person_display_name_level_7] NVARCHAR (100) NULL,
    [employee_people_leader_role_name_level_7]           NVARCHAR (100) NULL,
    [employee_people_leader_employee_number_level_8]     INT            NULL,
    [employee_people_leader_email_level_8]               NVARCHAR (100) NULL,
    [employee_people_leader_business_unit_name_level_8]  NVARCHAR (100) NULL,
    [employee_people_leader_person_display_name_level_8] NVARCHAR (100) NULL,
    [employee_people_leader_role_name_level_8]           NVARCHAR (100) NULL,
    [employee_people_leader_employee_number_level_9]     INT            NULL,
    [employee_people_leader_email_level_9]               NVARCHAR (100) NULL,
    [employee_people_leader_business_unit_name_level_9]  NVARCHAR (100) NULL,
    [employee_people_leader_person_display_name_level_9] NVARCHAR (100) NULL,
    [employee_people_leader_role_name_level_9]           NVARCHAR (100) NULL
);




GO
EXECUTE sp_addextendedproperty @name = N'sys_data_classification_recommendation_disabled', @value = 1, @level0type = N'SCHEMA', @level0name = N'staging', @level1type = N'TABLE', @level1name = N'ODSETLdim_employee_hierarchy', @level2type = N'COLUMN', @level2name = N'employee_people_leader_email_level_9';


GO
EXECUTE sp_addextendedproperty @name = N'sys_data_classification_recommendation_disabled', @value = 1, @level0type = N'SCHEMA', @level0name = N'staging', @level1type = N'TABLE', @level1name = N'ODSETLdim_employee_hierarchy', @level2type = N'COLUMN', @level2name = N'employee_people_leader_email_level_8';


GO
EXECUTE sp_addextendedproperty @name = N'sys_data_classification_recommendation_disabled', @value = 1, @level0type = N'SCHEMA', @level0name = N'staging', @level1type = N'TABLE', @level1name = N'ODSETLdim_employee_hierarchy', @level2type = N'COLUMN', @level2name = N'employee_people_leader_email_level_7';


GO
EXECUTE sp_addextendedproperty @name = N'sys_data_classification_recommendation_disabled', @value = 1, @level0type = N'SCHEMA', @level0name = N'staging', @level1type = N'TABLE', @level1name = N'ODSETLdim_employee_hierarchy', @level2type = N'COLUMN', @level2name = N'employee_people_leader_email_level_6';


GO
EXECUTE sp_addextendedproperty @name = N'sys_data_classification_recommendation_disabled', @value = 1, @level0type = N'SCHEMA', @level0name = N'staging', @level1type = N'TABLE', @level1name = N'ODSETLdim_employee_hierarchy', @level2type = N'COLUMN', @level2name = N'employee_people_leader_email_level_5';


GO
EXECUTE sp_addextendedproperty @name = N'sys_data_classification_recommendation_disabled', @value = 1, @level0type = N'SCHEMA', @level0name = N'staging', @level1type = N'TABLE', @level1name = N'ODSETLdim_employee_hierarchy', @level2type = N'COLUMN', @level2name = N'employee_people_leader_email_level_4';


GO
EXECUTE sp_addextendedproperty @name = N'sys_data_classification_recommendation_disabled', @value = 1, @level0type = N'SCHEMA', @level0name = N'staging', @level1type = N'TABLE', @level1name = N'ODSETLdim_employee_hierarchy', @level2type = N'COLUMN', @level2name = N'employee_people_leader_email_level_3';


GO
EXECUTE sp_addextendedproperty @name = N'sys_data_classification_recommendation_disabled', @value = 1, @level0type = N'SCHEMA', @level0name = N'staging', @level1type = N'TABLE', @level1name = N'ODSETLdim_employee_hierarchy', @level2type = N'COLUMN', @level2name = N'employee_people_leader_email_level_2';


GO
EXECUTE sp_addextendedproperty @name = N'sys_data_classification_recommendation_disabled', @value = 1, @level0type = N'SCHEMA', @level0name = N'staging', @level1type = N'TABLE', @level1name = N'ODSETLdim_employee_hierarchy', @level2type = N'COLUMN', @level2name = N'employee_people_leader_email_level_1';


GO
EXECUTE sp_addextendedproperty @name = N'sys_data_classification_recommendation_disabled', @value = 1, @level0type = N'SCHEMA', @level0name = N'staging', @level1type = N'TABLE', @level1name = N'ODSETLdim_employee_hierarchy', @level2type = N'COLUMN', @level2name = N'employee_primary_email_address';

