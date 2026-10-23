
CREATE VIEW [edw].[vw_fact_webexpenses] as 

/**********************************************************************************************************
 Table      [edw].[fact_webexpenses] 
 Author		Malhar Badheka	
 Created	2026-01-15		
 =========================================================================================================

REVISIONS:
Version	 Date			Author					Description
-------	------------	------------------		--------------------------
1.0		2026-01-15		Malhar Badheka			Initial creation of view 


**********************************************************************************************************/
SELECT [fact_webexpenses_key]
      ,[expense_key]
      ,[dim_webexpense_key]
      ,[claim_number]
      ,[dim_claimant_employee_key]
      ,[user_id]
      ,[expense_date]
      ,[expense_date_key]
      ,[posted_on]
      ,[posted_on_key]
      ,[upload_date]
      ,[upload_date_key]
      ,[amount]
      ,[base_amount]
      ,[exchange_rate]
      ,[billing_amount]
      ,[cc_exchange_rate]
      ,[dim_approver_employee_key]
      ,[DWHBatchId]
      ,[DWHEffectiveFrom]
      ,[DWHEffectiveTo]
      ,[DWHDMLOperation]
      ,[DWHIsCurrent]
      ,[DWHSourceSystem]
  FROM [edw].[fact_webexpenses]