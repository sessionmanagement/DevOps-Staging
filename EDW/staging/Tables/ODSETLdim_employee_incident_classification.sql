CREATE TABLE [staging].[ODSETLdim_employee_incident_classification] (
    [ODSdim_employee_incident_classificationID] INT             IDENTITY (1, 1) NOT NULL,
    [dim_employee_incident_id_key]              NVARCHAR (4000) NULL,
    [incident_id]                               NVARCHAR (4000) NULL,
    [incident_classification_level1_code]       NVARCHAR (100)  NULL,
    [incident_classification_level1_name]       NVARCHAR (1000) NULL,
    [incident_classification_level2_code]       NVARCHAR (100)  NULL,
    [incident_classification_level2_name]       NVARCHAR (1000) NULL,
    [incident_classification_level3_code]       NVARCHAR (100)  NULL,
    [incident_classification_level3_name]       NVARCHAR (1000) NULL,
    [incident_classification_notes]             NVARCHAR (4000) NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLdim_employee_incident_classification] PRIMARY KEY NONCLUSTERED ([ODSdim_employee_incident_classificationID] ASC)
);

