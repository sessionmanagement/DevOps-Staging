CREATE TABLE [landing].[edw_fact_client_incident_person] (
    [company_key]                 INT            NULL,
    [incident_id]                 INT            NULL,
    [client_id]                   INT            NULL,
    [incident_client_entity_type] NVARCHAR (50)  NULL,
    [incident_client_role]        NVARCHAR (150) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [fact_client_incident_person]
    ON [landing].[edw_fact_client_incident_person]([company_key] ASC, [incident_id] ASC, [client_id] ASC, [incident_client_entity_type] ASC, [incident_client_role] ASC);

