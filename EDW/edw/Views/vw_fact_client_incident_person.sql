

CREATE VIEW [edw].[vw_fact_client_incident_person]
AS

SELECT [fact_client_incident_person_key]
      ,[dim_client_incident_company_key_incident_id_key]
      ,[dim_company_key]
      ,[dim_client_incident_key]
      ,[dim_client_key]
      ,[incident_id]
      ,[client_id]
      ,[incident_client_entity_type]
      ,[incident_client_role]
      ,[DWHBatchId]
      ,[DWHEffectiveFrom]
      ,[DWHEffectiveTo]
      ,[DWHDMLOperation]
      ,[DWHIsCurrent]
      ,[DWHSourceSystem]
  FROM [edw].[fact_client_incident_person]