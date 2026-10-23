CREATE TABLE [landing].[edw_fact_client_incident_category] (
    [company_key]                    INT      NULL,
    [incident_id]                    INT      NULL,
    [incident_category_type_id]      INT      NULL,
    [incident_category_created_date] DATETIME NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [fact_client_incident_category]
    ON [landing].[edw_fact_client_incident_category]([company_key] ASC, [incident_id] ASC, [incident_category_type_id] ASC);

