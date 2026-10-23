CREATE TABLE [landing].[edw_dim_client_incident] (
    [company_key]                      INT            NULL,
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
    [incident_outcome_details]         NVARCHAR (MAX) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [dim_client_incident]
    ON [landing].[edw_dim_client_incident]([company_key] ASC, [incident_id] ASC);

