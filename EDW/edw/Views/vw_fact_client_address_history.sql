
CREATE VIEW [edw].[vw_fact_client_address_history]
AS

SELECT f.[fact_client_address_history_key]
      ,f.[fact_client_address_history_unique_key]
      ,f.[dim_company_key]
      ,f.[dim_client_key]
	  ,isnull(dc.[dim_client_key], CASE 
			WHEN f.client_id IS NOT NULL
				THEN - 1
			ELSE 0
			END) AS [dim_client_key_latest]
      ,f.[client_id]
      ,f.[client_address_id]
      ,f.[client_address_name]
      ,f.[client_address_line1]
      ,f.[client_address_line2]
      ,f.[client_address_line3]
      ,f.[client_address_suburb]
      ,f.[client_address_town_or_city]
      ,f.[client_address_post_code]
      ,f.[client_address_created_date_key]
      ,f.[client_address_start_date_key]
      ,f.[client_address_end_date_key]
      ,f.[client_address_is_postal_flag]
      ,f.[client_address_is_primary_flag]
      ,f.[DWHSourceSystem]
      ,f.[DWHBatchId]
      ,f.[DWHDMLOperation]
      ,f.[DWHModifiedOn]
      ,f.[DWHCreatedAt]
  FROM [edw].[fact_client_address_history] f
  LEFT JOIN [edw].[dim_client] dc ON f.client_id = dc.client_id
	AND f.dim_company_key = dc.[company_id]
	AND dc.DWHIsCurrent = 1