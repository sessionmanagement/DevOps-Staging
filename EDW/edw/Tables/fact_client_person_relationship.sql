CREATE TABLE [edw].[fact_client_person_relationship] (
    [fact_client_person_relationship_key]       INT            IDENTITY (100000, 1) NOT NULL,
    [fact_client_person_relationship_id]        INT            NOT NULL,
    [dim_company_key]                           INT            NOT NULL,
    [dim_employee_key]                          INT            NOT NULL,
    [dim_client_key]                            INT            NOT NULL,
    [dim_client_referral_key]                   INT            NOT NULL,
    [dim_client_team_key]                       INT            NOT NULL,
    [dim_service_key]                           INT            NOT NULL,
    [client_id]                                 INT            NULL,
    [client_responsible_user_id]                INT            NULL,
    [client_first_name]                         NVARCHAR (40)  NULL,
    [client_last_name]                          NVARCHAR (40)  NULL,
    [client_team_id]                            INT            NULL,
    [client_team_name]                          NVARCHAR (80)  NULL,
    [client_relationship_type]                  NVARCHAR (40)  NULL,
    [client_relationship_type_id]               INT            NULL,
    [client_referral_type]                      NVARCHAR (40)  NULL,
    [client_person_relationship_start_date]     INT            NULL,
    [client_person_relationship_end_date]       INT            NULL,
    [client_person_relationship_detail]         NVARCHAR (120) NULL,
    [client_person_relationship_user_id]        INT            NULL,
    [client_person_relationship_created_date]   INT            NULL,
    [client_referral_id]                        INT            NULL,
    [client_relationship_is_primary_caseworker] INT            NULL,
    [DWHSourceSystem]                           NVARCHAR (500) NOT NULL,
    [DWHBatchId]                                INT            NOT NULL,
    [DWHDMLOperation]                           CHAR (1)       NOT NULL,
    [DWHModifiedOn]                             DATETIME       NOT NULL,
    [DWHCreatedAt]                              DATETIME       NOT NULL,
    [client_referral_pending_date_key]          INT            NULL,
    CONSTRAINT [PK_EDW_person_relationship] PRIMARY KEY NONCLUSTERED ([fact_client_person_relationship_key] ASC)
);







