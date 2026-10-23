
CREATE VIEW edw.[vw_dim_webexpenses] as 

/**********************************************************************************************************
 Table      [edw].dim_webexpense] 
 Author		Malhar Badheka	
 Created	2026-01-15		
 =========================================================================================================

REVISIONS:
Version	 Date			Author					Description
-------	------------	------------------		--------------------------
1.0		2026-01-15		Malhar Badheka			Initial creation of view
1.1		2026-04-09		Malhar Badheka			Added receipt_available_flag column (#13162)


**********************************************************************************************************/

SELECT [dim_webexpense_key]
      ,[expense_key]
      ,[claim_number]
      ,[user_id]
      ,[claimant_login]
      ,[claimant_name]
      ,[approver_login]
      ,[approver_name]
      ,[company]
      ,[cost_center_id]
      ,[category_id]
      ,[category_name]
      ,[gl_code]
      ,[description]
      ,[status]
      ,[source]
      ,[currency_code]
      ,[billing_currency]
      ,[receipt_available_flag]
      ,[DWHBatchId]
      ,[DWHEffectiveFrom]
      ,[DWHEffectiveTo]
      ,[DWHDMLOperation]
      ,[DWHIsCurrent]
      ,[DWHSourceSystem]
  FROM [edw].[dim_webexpense]