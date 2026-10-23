CREATE TABLE [staging].[ODSETLfact_client_incident_category] (
    [fact_client_incident_category_key]                    INT      IDENTITY (1, 1) NOT NULL,
    [dim_client_incident_company_key_incident_id_key]      BIGINT   NULL,
    [dim_client_incident_company_key_category_type_id_key] BIGINT   NULL,
    [dim_company_key]                                      INT      NOT NULL,
    [dim_client_incident_key]                              INT      NOT NULL,
    [dim_client_incident_category_type_key]                INT      NOT NULL,
    [incident_id]                                          INT      NULL,
    [incident_category_type_id]                            INT      NULL,
    [incident_category_created_date]                       DATETIME NULL,
    CONSTRAINT [PK_Temp_Staging_ODSETLfact_client_incident_category] PRIMARY KEY NONCLUSTERED ([fact_client_incident_category_key] ASC)
);

