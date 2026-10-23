CREATE VIEW edw.vw_dim_client_interaction_type
As


SELECT [dim_client_interaction_type_key]
      ,[company_key]
      ,[client_interaction_type_id]
      ,[client_interaction_type_code]
      ,[client_interaction_type_name]
      ,[client_parent_interaction_type_code]
      ,[client_parent_interaction_type_name]
      ,[DWHBatchId]
      ,[DWHEffectiveFrom]
      ,[DWHEffectiveTo]
      ,[DWHDMLOperation]
      ,[DWHIsCurrent]
      ,[DWHSourceSystem]
  FROM [edw].[dim_client_interaction_type]