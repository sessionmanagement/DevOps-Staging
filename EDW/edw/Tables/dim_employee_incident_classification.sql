CREATE TABLE [edw].[dim_employee_incident_classification] (
    [dim_employee_incident_classification_key] INT             IDENTITY (1, 1) NOT NULL,
    [dim_employee_incident_id_key]             NVARCHAR (4000) NULL,
    [incident_id]                              NVARCHAR (4000) NULL,
    [incident_classification_level1_code]      NVARCHAR (100)  NULL,
    [incident_classification_level1_name]      NVARCHAR (1000) NULL,
    [incident_classification_level2_code]      NVARCHAR (100)  NULL,
    [incident_classification_level2_name]      NVARCHAR (1000) NULL,
    [incident_classification_level3_code]      NVARCHAR (100)  NULL,
    [incident_classification_level3_name]      NVARCHAR (1000) NULL,
    [incident_classification_notes]            NVARCHAR (4000) NULL,
    [DWHBatchId]                               INT             NOT NULL,
    [DWHCreatedAt]                             DATETIME        NOT NULL,
    [DWHModifiedOn]                            DATETIME        NOT NULL,
    [DWHDMLOperation]                          CHAR (1)        NOT NULL,
    [DWHSourceSystem]                          NVARCHAR (500)  NOT NULL,
    CONSTRAINT [PK__edw_dim_employee_incident_classification] PRIMARY KEY NONCLUSTERED ([dim_employee_incident_classification_key] ASC)
);

