CREATE TABLE [edw].[dim_client_incident_severity] (
    [dim_client_incident_severity_key]                INT            IDENTITY (1, 1) NOT NULL,
    [dim_client_incident_company_key_severity_id_key] BIGINT         NULL,
    [dim_company_key]                                 INT            NOT NULL,
    [incident_severity_id]                            INT            NULL,
    [incident_severity_value]                         NVARCHAR (200) NULL,
    [incident_severity_text]                          NVARCHAR (200) NULL,
    [is_incident_severity_active]                     INT            NULL,
    [DWHBatchId]                                      INT            NOT NULL,
    [DWHEffectiveFrom]                                DATETIME       NOT NULL,
    [DWHEffectiveTo]                                  DATETIME       NOT NULL,
    [DWHDMLOperation]                                 CHAR (1)       NOT NULL,
    [DWHIsCurrent]                                    BIT            NOT NULL,
    [DWHSourceSystem]                                 NVARCHAR (500) NOT NULL,
    CONSTRAINT [PK__edw_dim_client_incident_severity] PRIMARY KEY NONCLUSTERED ([dim_client_incident_severity_key] ASC)
);

