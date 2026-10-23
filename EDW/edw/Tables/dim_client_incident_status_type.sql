CREATE TABLE [edw].[dim_client_incident_status_type] (
    [dim_client_incident_status_type_key]                INT            IDENTITY (1, 1) NOT NULL,
    [dim_client_incident_company_key_status_type_id_key] BIGINT         NULL,
    [dim_company_key]                                    INT            NOT NULL,
    [incident_status_type_id]                            INT            NULL,
    [incident_status_type_code]                          NVARCHAR (30)  NULL,
    [incident_status_type_text]                          NVARCHAR (100) NULL,
    [incident_status_type_description]                   NVARCHAR (500) NULL,
    [incident_status_type_group]                         NVARCHAR (100) NULL,
    [DWHBatchId]                                         INT            NOT NULL,
    [DWHEffectiveFrom]                                   DATETIME       NOT NULL,
    [DWHEffectiveTo]                                     DATETIME       NOT NULL,
    [DWHDMLOperation]                                    CHAR (1)       NOT NULL,
    [DWHIsCurrent]                                       BIT            NOT NULL,
    [DWHSourceSystem]                                    NVARCHAR (500) NOT NULL,
    CONSTRAINT [PK__edw_dim_client_incident_status_type] PRIMARY KEY NONCLUSTERED ([dim_client_incident_status_type_key] ASC)
);

