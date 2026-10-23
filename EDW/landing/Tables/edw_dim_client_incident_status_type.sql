CREATE TABLE [landing].[edw_dim_client_incident_status_type] (
    [company_key]                      INT            NULL,
    [incident_status_type_id]          INT            NULL,
    [incident_status_type_code]        NVARCHAR (30)  NULL,
    [incident_status_type_text]        NVARCHAR (100) NULL,
    [incident_status_type_description] NVARCHAR (500) NULL,
    [incident_status_type_group]       NVARCHAR (100) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [dim_client_incident_status_type]
    ON [landing].[edw_dim_client_incident_status_type]([company_key] ASC, [incident_status_type_id] ASC);

