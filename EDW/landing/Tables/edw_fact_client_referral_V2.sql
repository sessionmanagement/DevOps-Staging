CREATE TABLE [landing].[edw_fact_client_referral_V2] (
    [company_key]                           INT           NULL,
    [client_referral_id]                    INT           NULL,
    [client_id]                             INT           NULL,
    [client_responsible_user_id]            INT           NULL,
    [client_team_id]                        INT           NULL,
    [uniquekey]                             NVARCHAR (94) NULL,
    [is_case_worker_flag]                   INT           NULL,
    [user_employee_number]                  INT           NULL,
    [client_referral_type]                  VARCHAR (32)  NULL,
    [client_person_relationship_start_date] INT           NULL,
    [client_person_relationship_end_date]   INT           NULL,
    [client_referral_received_date]         INT           NULL,
    [client_referral_created_date]          INT           NULL,
    [client_referral_end_date]              INT           NULL,
    [client_referral_pending_date]          INT           NULL,
    [client_referral_accepted_date]         INT           NULL,
    [client_referral_discharge_date]        INT           NULL,
    [client_referral_waitlist_date]         INT           NULL,
    [client_referral_decline_date]          INT           NULL,
    [client_hospital_nights]                INT           NULL,
    [client_absence]                        INT           NULL
);



