CREATE TABLE [landing].[edw_fact_client_person_relationship] (
    [company_id]                                INT           NULL,
    [client_person_relationship_id]             INT           NULL,
    [client_id]                                 INT           NULL,
    [client_responsible_user_id]                INT           NULL,
    [client_first_name]                         VARCHAR (40)  NULL,
    [client_last_name]                          VARCHAR (40)  NULL,
    [client_team_id]                            INT           NULL,
    [client_team_name]                          VARCHAR (80)  NULL,
    [client_relationship_type]                  VARCHAR (40)  NULL,
    [client_relationship_type_id]               INT           NULL,
    [client_referral_type]                      VARCHAR (32)  NULL,
    [client_person_relationship_start_date]     INT           NULL,
    [client_person_relationship_end_date]       INT           NULL,
    [client_person_relationship_detail]         VARCHAR (120) NULL,
    [client_person_relationship_user_id]        INT           NULL,
    [client_person_relationship_created_date]   INT           NULL,
    [client_referral_id]                        INT           NULL,
    [client_relationship_is_primary_caseworker] INT           NULL,
    [user_employee_number]                      VARCHAR (50)  NULL
);







