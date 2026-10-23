CREATE PROC [staging].[insert_staging_fact_property_tenancy_transaction]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_property_tenancy_transaction]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2024-06-30    ?				Initial version
1.1      2026-02-20    GitHub Copilot    Removed redundant columns per work item 12210

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_property_tenancy_transaction]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_property_tenancy_transaction] (
	 [property_tenancy_transaction_id] 
	,[property_id] 
	,[property_tenancy_id] 
	,[property_program_id] 
	,[property_subprogram_id] 
	,[property_tenancy_transaction_date_id] 
	,[property_tenancy_transaction_rent_from_date_id] 
	,[property_tenancy_transaction_rent_to_date_id] 
	,[property_tenancy_transaction_rent_paid_to_date_id] 
	,[property_tenancy_transaction_as_at_date_id] 
	,[property_tenancy_transaction_name] 
	,[property_tenancy_transaction_type_code] 
	,[property_tenancy_transaction_type] 
	,[property_tenancy_transaction_account_type] 
	,[property_tenancy_transaction_subtransaction_name] 
	,[property_tenancy_transaction_comments] 
	,[property_tenancy_transaction_state] 
	,[property_tenancy_transaction_status]
	,[property_tenancy_transaction_payment_type_id]
	,[property_tenancy_transaction_rent_nonrent] 
	,[property_tenancy_transaction_credit_debit] 
	,[property_tenancy_transaction_arrears_arrangement] 
	,[property_tenancy_transaction_import_payment_name] 
	,[property_tenancy_transaction_rent_generation_batch] 
	,[property_tenancy_transaction_bc_entry_number] 
	,[property_tenancy_transaction_amount] 
	,[property_tenancy_transaction_balance_non_rent] 
	,[property_tenancy_transaction_balance_rent] 
	,[property_tenancy_transaction_balance_total] 
	,[property_tenancy_transaction_receipt_number] 
	,[property_tenancy_transaction_suspense_account_flag] 
	,[property_tenancy_transaction_from_zavanti_import_flag] 
	,[property_tenancy_transaction_created_datetime] 
	,[property_tenancy_transaction_modified_datetime] 
	,[property_tenancy_transaction_is_delete_flag] 
	)
SELECT
	 [property_tenancy_transaction_id] 
	,[property_id] 
	,[property_tenancy_id] 
	,[property_program_id] 
	,[property_subprogram_id] 
	,[property_tenancy_transaction_date_id] 
	,[property_tenancy_transaction_rent_from_date_id] 
	,[property_tenancy_transaction_rent_to_date_id] 
	,[property_tenancy_transaction_rent_paid_to_date_id] 
	,[property_tenancy_transaction_as_at_date_id] 
	,[property_tenancy_transaction_name] 
	,[property_tenancy_transaction_type_code] 
	,[property_tenancy_transaction_type] 
	,[property_tenancy_transaction_account_type] 
	,[property_tenancy_transaction_subtransaction_name] 
	,[property_tenancy_transaction_comments] 
	,[property_tenancy_transaction_state] 
	,[property_tenancy_transaction_status]
	,[property_tenancy_transaction_payment_type_id]
	,[property_tenancy_transaction_rent_nonrent] 
	,[property_tenancy_transaction_credit_debit] 
	,[property_tenancy_transaction_arrears_arrangement] 
	,[property_tenancy_transaction_import_payment_name] 
	,[property_tenancy_transaction_rent_generation_batch] 
	,[property_tenancy_transaction_bc_entry_number] 
	,[property_tenancy_transaction_amount] 
	,[property_tenancy_transaction_balance_non_rent] 
	,[property_tenancy_transaction_balance_rent] 
	,[property_tenancy_transaction_balance_total] 
	,[property_tenancy_transaction_receipt_number] 
	,[property_tenancy_transaction_suspense_account_flag] 
	,[property_tenancy_transaction_from_zavanti_import_flag] 
	,[property_tenancy_transaction_created_datetime] 
	,[property_tenancy_transaction_modified_datetime] 
	,[property_tenancy_transaction_is_delete_flag] 
from [Landing].[edw_fact_property_tenancy_transaction]