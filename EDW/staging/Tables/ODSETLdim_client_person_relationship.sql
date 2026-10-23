CREATE TABLE [staging].[ODSETLdim_client_person_relationship] (
    [company_id]                                INT            NULL,
    [client_person_relationship_id]             INT            NULL,
    [client_person_relationship_unique_key]     NVARCHAR (100) NOT NULL,
    [client_id]                                 INT            NULL,
    [client_responsible_user_id]                INT            NULL,
    [client_first_name]                         NVARCHAR (40)  NULL,
    [client_last_name]                          NVARCHAR (40)  NULL,
    [client_team_id]                            INT            NULL,
    [client_team_name]                          NVARCHAR (80)  NULL,
    [client_relationship_type]                  NVARCHAR (40)  NULL,
    [client_referral_type]                      NVARCHAR (40)  NULL,
    [client_person_relationship_start_date]     DATE           NULL,
    [client_person_relationship_end_date]       DATE           NULL,
    [client_person_relationship_detail]         NVARCHAR (40)  NULL,
    [client_person_relationship_user_id]        INT            NULL,
    [client_person_relationship_created_date]   DATE           NULL,
    [client_referral_id]                        INT            NULL,
    [client_relationship_is_primary_caseworker] INT            NULL,
    [user_employee_number]                      NVARCHAR (50)  NULL,
    [client_referral_status_type_description]   NVARCHAR (100) NULL,
    [client_referral_status_type_code]          NVARCHAR (40)  NULL,
    [client_referral_status_type_group]         NVARCHAR (40)  NULL,
    [client_referral_caseworker]                NVARCHAR (70)  NULL,
    [client_relationship_type_text]             NVARCHAR (100) NULL,
    [client_relationship_type_value]            NVARCHAR (40)  NULL
);







