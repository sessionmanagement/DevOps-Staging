CREATE TABLE [landing].[edw_dim_employee_incident] (
    [incident_id]                             NVARCHAR (4000) NULL,
    [incident_title]                          NVARCHAR (4000) NULL,
    [current_stage]                           NVARCHAR (4000) NULL,
    [active_stage_status]                     NVARCHAR (4000) NULL,
    [incident_details]                        NVARCHAR (4000) NULL,
    [incident_business_unit]                  NVARCHAR (255)  NULL,
    [incident_sub_unit]                       NVARCHAR (255)  NULL,
    [incident_team]                           NVARCHAR (255)  NULL,
    [incident_specific_location]              NVARCHAR (4000) NULL,
    [incident_site_address]                   NVARCHAR (4000) NULL,
    [incident_who_is_involved]                NVARCHAR (4000) NULL,
    [incident_nature_of_eyewitness]           NVARCHAR (4000) NULL,
    [actual_likelihood_guidance]              NVARCHAR (255)  NULL,
    [actual_likelihood_occurrence]            NVARCHAR (255)  NULL,
    [actual_severity_level]                   NVARCHAR (255)  NULL,
    [actual_severity_consequence]             NVARCHAR (255)  NULL,
    [ongoing_risk_likelihood_guidance]        NVARCHAR (255)  NULL,
    [ongoing_risk_expected_outcome]           NVARCHAR (255)  NULL,
    [ongoing_risk_level]                      NVARCHAR (255)  NULL,
    [ongoing_risk_reoccurrence_likelihood]    NVARCHAR (255)  NULL,
    [incident_primary_location]               NVARCHAR (1000) NULL,
    [incident_locations_list]                 NVARCHAR (4000) NULL,
    [is_abuse_procedure_in_place]             VARCHAR (1)     NULL,
    [is_assault_procedure_in_place]           VARCHAR (1)     NULL,
    [is_fire_risk_cooking_procedure_in_place] VARCHAR (1)     NULL,
    [is_fire_risk_other_procedure_in_place]   VARCHAR (1)     NULL,
    [is_smoking_procedure_in_place]           VARCHAR (1)     NULL,
    [is_investigation_completed]              VARCHAR (1)     NULL,
    [incident_immediate_actions_taken]        NVARCHAR (4000) NULL,
    [is_incident_in_recordbase]               VARCHAR (1)     NULL,
    [incident_recordbase_detail]              NVARCHAR (4000) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [dim_employee_incident]
    ON [landing].[edw_dim_employee_incident]([incident_id] ASC);

