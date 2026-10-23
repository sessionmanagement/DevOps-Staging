

CREATE VIEW [edw].[vw_fact_client_incident_category]
AS

SELECT [fact_client_incident_category_key]
      ,[dim_client_incident_company_key_incident_id_key]
      ,[dim_client_incident_company_key_category_type_id_key]
      ,[dim_company_key]
      ,[dim_client_incident_key]
      ,[dim_client_incident_category_type_key]
      ,[incident_id]
      ,[incident_category_type_id]
      ,[incident_category_created_date]
      ,[DWHBatchId]
      ,[DWHEffectiveFrom]
      ,[DWHEffectiveTo]
      ,[DWHDMLOperation]
      ,[DWHIsCurrent]
      ,[DWHSourceSystem]
  FROM [edw].[fact_client_incident_category]