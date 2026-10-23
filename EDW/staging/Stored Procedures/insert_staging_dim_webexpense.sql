CREATE PROC [staging].[insert_staging_dim_webexpense]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_webexpense]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-12-12    ?				Initial version
1.1		 2026-04-09    Malhar Badheka	Added receipt_available_flag column (#13162)

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_webexpense]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_webexpense] (
	 [expense_key] 
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
	)
SELECT
	 [expense_key] 
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
from [Landing].[edw_dim_webexpense]