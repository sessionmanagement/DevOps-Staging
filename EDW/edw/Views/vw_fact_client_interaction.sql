CREATE VIEW edw.vw_fact_client_interaction
As


SELECT [fact_client_interaction_key]
      ,[dim_company_key]
      ,[client_interaction_id]
      ,[client_id]
      ,[client_interaction_type_id]
      ,[dim_client_key]
      ,[dim_client_interaction_type_key]
      ,[dim_employee_key]
      ,[client_interaction_date]
      ,[client_interaction_created_date]
      ,[client_interaction_comments]
      ,[DWHBatchId]
      ,[DWHCreatedAt]
      ,[DWHModifiedOn]
      ,[DWHDMLOperation]
      ,[DWHSourceSystem]
  FROM [edw].[fact_client_interaction]