CREATE TABLE [edw].[dim_client_incident] (
    [dim_client_incident_key]                         INT            IDENTITY (1, 1) NOT NULL,
    [dim_client_incident_company_key_incident_id_key] BIGINT         NULL,
    [dim_company_key]                                 INT            NOT NULL,
    [incident_id]                                     INT            NULL,
    [incident_date]                                   DATETIME       NULL,
    [incident_title]                                  NVARCHAR (500) NULL,
    [incident_description]                            NVARCHAR (MAX) NULL,
    [incident_location]                               NVARCHAR (MAX) NULL,
    [incident_immediate_action_taken]                 NVARCHAR (MAX) NULL,
    [incident_possible_prevention]                    NVARCHAR (MAX) NULL,
    [incident_further_action_required]                NVARCHAR (MAX) NULL,
    [incident_investigation_details]                  NVARCHAR (MAX) NULL,
    [incident_created_date]                           DATETIME       NULL,
    [incident_outcome_details]                        NVARCHAR (MAX) NULL,
    [DWHBatchId]                                      INT            NOT NULL,
    [DWHEffectiveFrom]                                DATETIME       NOT NULL,
    [DWHEffectiveTo]                                  DATETIME       NOT NULL,
    [DWHDMLOperation]                                 CHAR (1)       NOT NULL,
    [DWHIsCurrent]                                    BIT            NOT NULL,
    [DWHSourceSystem]                                 NVARCHAR (500) NOT NULL,
    CONSTRAINT [PK__edw_dim_client_incident] PRIMARY KEY NONCLUSTERED ([dim_client_incident_key] ASC)
);

