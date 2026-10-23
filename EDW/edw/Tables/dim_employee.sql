CREATE TABLE [edw].[dim_employee] (
    [dim_employee_key]                            INT                                                                       IDENTITY (0, 1) NOT NULL,
    [employee_id]                                 INT                                                                       NOT NULL,
    [employee_name]                               NVARCHAR (100)                                                            NOT NULL,
    [employee_first_name]                         NVARCHAR (75)                                                             NULL,
    [employee_middle_name]                        NVARCHAR (75)                                                             NULL,
    [employee_last_name]                          NVARCHAR (100)                                                            NULL,
    [employee_title]                              NVARCHAR (10)                                                             NULL,
    [employee_preferred_name]                     NVARCHAR (75)                                                             NULL,
    [employee_employment_status]                  NVARCHAR (50)                                                             NULL,
    [employee_nhi_number]                         VARCHAR (1)                                                               NULL,
    [employee_profile_system_id]                  NVARCHAR (50)                                                             NULL,
    [employee_workrights_name]                    NVARCHAR (100)                                                            NULL,
    [employee_workrights_country]                 NVARCHAR (50)                                                             NULL,
    [employee_workrights_expiration_date]         DATETIME2 (7)                                                             NULL,
    [employee_employment_condition]               NVARCHAR (100)                                                            NULL,
    [employee_primary_email_address]              NVARCHAR (100)                                                            NULL,
    [employee_primary_email_address_ispersonal]   INT                                                                       NULL,
    [employee_primary_phone_number]               NVARCHAR (200)                                                            NULL,
    [employee_primary_phone_number_fullnumber]    NVARCHAR (200)                                                            NULL,
    [employee_primary_phone_number_ispersonal]    INT                                                                       NULL,
    [employee_city_value]                         NVARCHAR (100)                                                            NULL,
    [employee_address_Type]                       NVARCHAR (10)                                                             NULL,
    [employee_full_address]                       NVARCHAR (150)                                                            NULL,
    [employee_street_value]                       NVARCHAR (50)                                                             NULL,
    [employee_suburb_value]                       NVARCHAR (50)                                                             NULL,
    [employee_postcode_value]                     NVARCHAR (10)                                                             NULL,
    [employee_is_primary_address_flag]            INT                                                                       NULL,
    [employee_emergency_contact_name]             NVARCHAR (150)                                                            NULL,
    [employee_next_of_whanau_relationship]        NVARCHAR (100)                                                            NULL,
    [employee_next_of_whanau_phone]               NVARCHAR (200)                                                            NULL,
    [employee_next_of_whanau_email]               NVARCHAR (100)                                                            NULL,
    [employee_company_name]                       NVARCHAR (200)                                                            NULL,
    [employee_company_start_date]                 DATETIME2 (7)                                                             NULL,
    [employee_start_date]                         DATETIME2 (7)                                                             NULL,
    [employee_company_end_date]                   DATETIME2 (7)                                                             NULL,
    [employee_end_date]                           DATETIME2 (7)                                                             NULL,
    [employee_position_start_date]                DATETIME2 (7)                                                             NULL,
    [employee_gender]                             NVARCHAR (50)                                                             NULL,
    [employee_previous_gender]                    NVARCHAR (50)                                                             NULL,
    [employee_previous_gender_valid_to_date]      DATETIME2 (7)                                                             NULL,
    [employee_date_of_birth]                      DATETIME2 (7)                                                             NULL,
    [employee_age_in_year]                        INT                                                                       NULL,
    [employee_age_group]                          NVARCHAR (10)                                                             NULL,
    [employee_longevity]                          DATETIME2 (7)                                                             NULL,
    [employee_termination_date]                   DATETIME2 (7)                                                             NULL,
    [employee_long_service_recognition_date]      VARCHAR (10)                                                              NULL,
    [employee_work_type]                          NVARCHAR (50)                                                             NULL,
    [employee_work_class]                         NVARCHAR (50)                                                             NULL,
    [employee_ethnicity]                          NVARCHAR (4000)                                                           NULL,
    [employee_pay_grade_name]                     NVARCHAR (50)                                                             NULL,
    [employee_remuneration_annual_package]        FLOAT (53)                                                                NULL,
    [employee_remuneration_base_annual_salary]    FLOAT (53)                                                                NULL,
    [employee_remuneration_base_hourly_rate]      FLOAT (53)                                                                NULL,
    [employee_remuneration_schedule_currency]     NVARCHAR (3)                                                              NULL,
    [employee_remuneration_hours_per_cycle]       FLOAT (53)                                                                NULL,
    [employee_remuneration_pay_cycle]             NVARCHAR (50)                                                             NULL,
    [employee_remuneration_hourly_package]        FLOAT (53)                                                                NULL,
    [employee_leaving_date]                       DATETIME2 (7)                                                             NULL,
    [employee_leaving_reason]                     NVARCHAR (255)                                                            NULL,
    [employee_leaving_turnover_type]              NVARCHAR (255)                                                            NULL,
    [employee_exemption_granted]                  NVARCHAR (500)                                                            NULL,
    [employee_nationality]                        NVARCHAR (500)                                                            NULL,
    [employee_concurrent_job]                     NVARCHAR (500)                                                            NULL,
    [employee_identified_ethnicity]               NVARCHAR (500)                                                            NULL,
    [employee_hapu_affilitation]                  NVARCHAR (500)                                                            NULL,
    [employee_ot_vetting]                         NVARCHAR (500)                                                            NULL,
    [employee_preferred_last_name]                NVARCHAR (500)                                                            NULL,
    [employee_annual_practising_cert_expiry_date] DATETIME2 (7)                                                             NULL,
    [employee_exception_police_vetting_expiry]    DATETIME2 (7)                                                             NULL,
    [employee_mask_exemption]                     NVARCHAR (500)                                                            NULL,
    [employee_vaccine_status]                     NVARCHAR (4000)                                                           NULL,
    [employee_smoking_status]                     NVARCHAR (500)                                                            NULL,
    [employee_people_manager_job_status]          NVARCHAR (100)                                                            NULL,
    [employee_people_manager_job_name]            NVARCHAR (100)                                                            NULL,
    [employee_people_manager_name]                NVARCHAR (100)                                                            NULL,
    [employee_people_manager_id]                  NVARCHAR (100)                                                            NULL,
    [employee_ird_number]                         VARCHAR (1)                                                               NULL,
    [employee_is_primary_Job_flag]                INT                                                                       NULL,
    [extended_leave_type_name]                    NVARCHAR (100)                                                            NULL,
    [extended_leave_start_date]                   DATETIME2 (7)                                                             NULL,
    [extended_leave_end_date]                     DATETIME2 (7)                                                             NULL,
    [DWHSourceSystem]                             NVARCHAR (500)                                                            NOT NULL,
    [DWHBatchId]                                  INT                                                                       NOT NULL,
    [DWHDMLOperation]                             CHAR (1)                                                                  NOT NULL,
    [DWHEffectiveFrom]                            DATETIME                                                                  NOT NULL,
    [DWHEffectiveTo]                              DATETIME                                                                  NOT NULL,
    [DWHIsCurrent]                                INT                                                                       NOT NULL,
    [employee_job_name]                           NVARCHAR (100)                                                            NULL,
    [primary_ethnicity_id]                        INT                                                                       NULL,
    [secondary_ethnicity_id]                      INT                                                                       NULL,
    [tertiary_ethnicity_id]                       INT                                                                       NULL,
    [fourth_ethnicity_id]                         INT                                                                       NULL,
    [primary_iwi_id]                              INT                                                                       NULL,
    [identified_ethnicity_id]                     INT                                                                       NULL,
    [employee_full_time_equivalent]               NUMERIC (12, 6)                                                           NULL,
    [employee_job_status]                         NVARCHAR (50)                                                             NULL,
    [employee_salary_sacrifice]                   NVARCHAR (50) MASKED WITH (FUNCTION = 'default()')                        NULL,
    [employee_bank_details]                       NVARCHAR (50) MASKED WITH (FUNCTION = 'partial(0, "XXXX-XXXX-XXXX-", 4)') NULL,
    [employee_incidents]                          NVARCHAR (100)                                                            NULL,
    [employee_latest_incident_date]               NVARCHAR (100)                                                            NULL,
    [employee_disciplinary_status]                NVARCHAR (100)                                                            NULL,
    [employee_specific_needs]                     NVARCHAR (100)                                                            NULL,
    [employee_qualification_level]                NVARCHAR (100)                                                            NULL,
    [employee_referral_source]                    NVARCHAR (100)                                                            NULL,
    [employee_current_status]                     NVARCHAR (20)                                                             NULL,
    CONSTRAINT [PK_EDW_dim_employee] PRIMARY KEY NONCLUSTERED ([dim_employee_key] ASC)
);




















GO
ADD SENSITIVITY CLASSIFICATION TO
    [edw].[dim_employee].[employee_first_name]
    WITH (LABEL = 'Confidential - GDPR', LABEL_ID = '5ebb0195-7f81-4a07-b164-18861153437d', INFORMATION_TYPE = 'Name', INFORMATION_TYPE_ID = '57845286-7598-22f5-9659-15b24aeb125e', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [edw].[dim_employee].[employee_last_name]
    WITH (LABEL = 'Confidential - GDPR', LABEL_ID = '5ebb0195-7f81-4a07-b164-18861153437d', INFORMATION_TYPE = 'Name', INFORMATION_TYPE_ID = '57845286-7598-22f5-9659-15b24aeb125e', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [edw].[dim_employee].[employee_workrights_expiration_date]
    WITH (LABEL = 'Confidential', LABEL_ID = '61d824ec-5c78-4a3d-8b0d-612d227e20fb', INFORMATION_TYPE = 'Credit Card', INFORMATION_TYPE_ID = 'd22fa6e9-5ee4-3bde-4c2b-a409604c4646', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [edw].[dim_employee].[employee_primary_email_address]
    WITH (LABEL = 'Confidential', LABEL_ID = '61d824ec-5c78-4a3d-8b0d-612d227e20fb', INFORMATION_TYPE = 'Contact Info', INFORMATION_TYPE_ID = '5c503e21-22c6-81fa-620b-f369b8ec38d1', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [edw].[dim_employee].[employee_primary_email_address_ispersonal]
    WITH (LABEL = 'Confidential', LABEL_ID = '61d824ec-5c78-4a3d-8b0d-612d227e20fb', INFORMATION_TYPE = 'Other', INFORMATION_TYPE_ID = '9c5b4809-0ccc-0637-6547-91a6f8bb609d', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [edw].[dim_employee].[employee_primary_phone_number]
    WITH (LABEL = 'Confidential', LABEL_ID = '61d824ec-5c78-4a3d-8b0d-612d227e20fb', INFORMATION_TYPE = 'Contact Info', INFORMATION_TYPE_ID = '5c503e21-22c6-81fa-620b-f369b8ec38d1', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [edw].[dim_employee].[employee_primary_phone_number_fullnumber]
    WITH (LABEL = 'Confidential', LABEL_ID = '61d824ec-5c78-4a3d-8b0d-612d227e20fb', INFORMATION_TYPE = 'Contact Info', INFORMATION_TYPE_ID = '5c503e21-22c6-81fa-620b-f369b8ec38d1', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [edw].[dim_employee].[employee_primary_phone_number_ispersonal]
    WITH (LABEL = 'Confidential', LABEL_ID = '61d824ec-5c78-4a3d-8b0d-612d227e20fb', INFORMATION_TYPE = 'Contact Info', INFORMATION_TYPE_ID = '5c503e21-22c6-81fa-620b-f369b8ec38d1', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [edw].[dim_employee].[employee_city_value]
    WITH (LABEL = 'Confidential', LABEL_ID = '61d824ec-5c78-4a3d-8b0d-612d227e20fb', INFORMATION_TYPE = 'Contact Info', INFORMATION_TYPE_ID = '5c503e21-22c6-81fa-620b-f369b8ec38d1', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [edw].[dim_employee].[employee_address_Type]
    WITH (LABEL = 'Confidential', LABEL_ID = '61d824ec-5c78-4a3d-8b0d-612d227e20fb', INFORMATION_TYPE = 'Contact Info', INFORMATION_TYPE_ID = '5c503e21-22c6-81fa-620b-f369b8ec38d1', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [edw].[dim_employee].[employee_full_address]
    WITH (LABEL = 'Confidential', LABEL_ID = '61d824ec-5c78-4a3d-8b0d-612d227e20fb', INFORMATION_TYPE = 'Contact Info', INFORMATION_TYPE_ID = '5c503e21-22c6-81fa-620b-f369b8ec38d1', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [edw].[dim_employee].[employee_street_value]
    WITH (LABEL = 'Confidential', LABEL_ID = '61d824ec-5c78-4a3d-8b0d-612d227e20fb', INFORMATION_TYPE = 'Contact Info', INFORMATION_TYPE_ID = '5c503e21-22c6-81fa-620b-f369b8ec38d1', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [edw].[dim_employee].[employee_next_of_whanau_phone]
    WITH (LABEL = 'Confidential', LABEL_ID = '61d824ec-5c78-4a3d-8b0d-612d227e20fb', INFORMATION_TYPE = 'Contact Info', INFORMATION_TYPE_ID = '5c503e21-22c6-81fa-620b-f369b8ec38d1', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [edw].[dim_employee].[employee_next_of_whanau_email]
    WITH (LABEL = 'Confidential', LABEL_ID = '61d824ec-5c78-4a3d-8b0d-612d227e20fb', INFORMATION_TYPE = 'Contact Info', INFORMATION_TYPE_ID = '5c503e21-22c6-81fa-620b-f369b8ec38d1', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [edw].[dim_employee].[employee_date_of_birth]
    WITH (LABEL = 'Confidential - GDPR', LABEL_ID = '5ebb0195-7f81-4a07-b164-18861153437d', INFORMATION_TYPE = 'Date Of Birth', INFORMATION_TYPE_ID = '3de7cc52-710d-4e96-7e20-4d5188d2590c', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [edw].[dim_employee].[employee_ethnicity]
    WITH (LABEL = 'Confidential', LABEL_ID = '61d824ec-5c78-4a3d-8b0d-612d227e20fb', INFORMATION_TYPE = 'Contact Info', INFORMATION_TYPE_ID = '5c503e21-22c6-81fa-620b-f369b8ec38d1', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [edw].[dim_employee].[employee_identified_ethnicity]
    WITH (LABEL = 'Confidential', LABEL_ID = '61d824ec-5c78-4a3d-8b0d-612d227e20fb', INFORMATION_TYPE = 'Contact Info', INFORMATION_TYPE_ID = '5c503e21-22c6-81fa-620b-f369b8ec38d1', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [edw].[dim_employee].[employee_preferred_last_name]
    WITH (LABEL = 'Confidential - GDPR', LABEL_ID = '5ebb0195-7f81-4a07-b164-18861153437d', INFORMATION_TYPE = 'Name', INFORMATION_TYPE_ID = '57845286-7598-22f5-9659-15b24aeb125e', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [edw].[dim_employee].[employee_annual_practising_cert_expiry_date]
    WITH (LABEL = 'Confidential', LABEL_ID = '61d824ec-5c78-4a3d-8b0d-612d227e20fb', INFORMATION_TYPE = 'Credit Card', INFORMATION_TYPE_ID = 'd22fa6e9-5ee4-3bde-4c2b-a409604c4646', RANK = MEDIUM);


GO
ADD SENSITIVITY CLASSIFICATION TO
    [edw].[dim_employee].[employee_exception_police_vetting_expiry]
    WITH (LABEL = 'Confidential', LABEL_ID = '61d824ec-5c78-4a3d-8b0d-612d227e20fb', INFORMATION_TYPE = 'Credit Card', INFORMATION_TYPE_ID = 'd22fa6e9-5ee4-3bde-4c2b-a409604c4646', RANK = MEDIUM);


GO

