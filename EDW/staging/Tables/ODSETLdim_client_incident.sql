CREATE TABLE [staging].[ODSETLdim_client_incident] (
    [ODSdim_client_incidentID]         INT            IDENTITY (1, 1) NOT NULL,
    [company_key_incident_id]          BIGINT         NULL,
    [company_key]                      INT            NOT NULL,
    [incident_id]                      INT            NULL,
    [incident_date]                    DATETIME       NULL,
    [incident_title]                   NVARCHAR (500) NULL,
    [incident_description]             NVARCHAR (MAX) NULL,
    [incident_location]                NVARCHAR (MAX) NULL,
    [incident_immediate_action_taken]  NVARCHAR (MAX) NULL,
    [incident_possible_prevention]     NVARCHAR (MAX) NULL,
    [incident_further_action_required] NVARCHAR (MAX) NULL,
    [incident_investigation_details]   NVARCHAR (MAX) NULL,
    [incident_created_date]            DATETIME       NULL,
    [incident_outcome_details]         NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLdim_client_incident] PRIMARY KEY NONCLUSTERED ([ODSdim_client_incidentID] ASC)
);

