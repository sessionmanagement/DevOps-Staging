CREATE TABLE [landing].[edw_dim_client_incident_severity] (
    [company_key]                 INT            NULL,
    [incident_severity_id]        INT            NULL,
    [incident_severity_value]     NVARCHAR (200) NULL,
    [incident_severity_text]      NVARCHAR (200) NULL,
    [is_incident_severity_active] INT            NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [dim_client_incident_severity]
    ON [landing].[edw_dim_client_incident_severity]([company_key] ASC, [incident_severity_id] ASC);

