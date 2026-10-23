CREATE TABLE [staging].[ODSETLfact_client_referral] (
    [client_referral_id]                                 INT            NOT NULL,
    [client_id]                                          INT            NOT NULL,
    [client_referral_responsible_user_id]                INT            NULL,
    [client_team_id]                                     INT            NULL,
    [fact_client_referral_unique_key]                    NVARCHAR (150) NOT NULL,
    [company_id]                                         INT            NOT NULL,
    [user_employee_number]                               NVARCHAR (50)  NULL,
    [client_referral_type]                               VARCHAR (50)   NULL,
    [client_referral_person_relationship_start_date_key] INT            NULL,
    [client_referral_person_relationship_end_date_key]   INT            NULL,
    [client_referral_received_date_key]                  INT            NULL,
    [client_referral_created_date_key]                   INT            NULL,
    [client_referral_end_date_key]                       INT            NULL,
    [client_referral_discharge_date_key]                 INT            NULL,
    [client_referral_accepted_date_key]                  INT            NULL,
    [client_referral_waitlist_date_key]                  INT            NULL,
    [client_referral_decline_date_key]                   INT            NULL,
    [client_referral_bed_nights]                         INT            NULL,
    [client_referral_hospital_nights]                    INT            NULL,
    [client_referral_absence]                            INT            NULL,
    [client_referral_pending_date_key]                   INT            NULL
);






GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_fact_referral]
    ON [staging].[ODSETLfact_client_referral]([fact_client_referral_unique_key] ASC);

