CREATE TABLE [landing].[edw_dim_employee_incident_classification] (
    [incident_id]                         NVARCHAR (4000) NULL,
    [incident_classification_level1_code] NVARCHAR (100)  NULL,
    [incident_classification_level1_name] NVARCHAR (1000) NULL,
    [incident_classification_level2_code] NVARCHAR (100)  NULL,
    [incident_classification_level2_name] NVARCHAR (1000) NULL,
    [incident_classification_level3_code] NVARCHAR (100)  NULL,
    [incident_classification_level3_name] NVARCHAR (1000) NULL,
    [incident_classification_notes]       NVARCHAR (4000) NULL
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [dim_employee_incident_classification]
    ON [landing].[edw_dim_employee_incident_classification]([incident_id] ASC, [incident_classification_level1_code] ASC, [incident_classification_level2_code] ASC, [incident_classification_level3_code] ASC);

