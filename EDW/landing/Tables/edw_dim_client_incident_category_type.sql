CREATE TABLE [landing].[edw_dim_client_incident_category_type] (
    [company_key]                        INT            NULL,
    [incident_category_type_id]          INT            NULL,
    [incident_category_type_text]        NVARCHAR (200) NULL,
    [incident_category_type_parent_Id]   INT            NULL,
    [incident_category_type_parent_text] NVARCHAR (200) NULL,
    [is_incident_category_type_active]   INT            NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [dim_client_incident_category_type]
    ON [landing].[edw_dim_client_incident_category_type]([company_key] ASC, [incident_category_type_id] ASC);

