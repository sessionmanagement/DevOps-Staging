-- Updated 2026-02-20 for work item 12210 - Property field improvements

CREATE VIEW [edw].[vw_fact_property_tenancy_transaction]
AS

    SELECT f.[fact_property_tenancy_transaction_id]
	, f.[property_tenancy_transaction_id]
	, f.[dim_property_key]
	, isnull(dp.[dim_property_key], CASE 
			WHEN f.[property_id] IS NOT NULL
				THEN - 1
			ELSE 0
			END) AS [dim_property_key_latest]
	, f.[dim_property_detail_key]
	, isnull(dpd.[dim_property_detail_key], CASE 
			WHEN f.[property_id] IS NOT NULL
				THEN - 1
			ELSE 0
			END) AS [dim_property_detail_key_latest]
	, f.[dim_property_healthy_homes_key]
	, isnull(dphh.[dim_property_healthy_homes_key], CASE 
			WHEN f.[property_id] IS NOT NULL
				THEN - 1
			ELSE 0
			END) AS [dim_property_healthy_homes_key_latest]
	, f.[dim_property_tenancy_key]
	, isnull(dpt.[dim_property_tenancy_key], CASE 
			WHEN f.[property_tenancy_id] IS NOT NULL
				THEN - 1
			ELSE 0
			END) AS [dim_property_tenancy_key_latest]
	, f.[dim_property_program_key]
	, isnull(dpp.[dim_property_program_id], CASE 
			WHEN f.[property_program_id] IS NOT NULL
				THEN - 1
			ELSE 0
			END) AS [dim_property_program_key_latest]
	, f.[property_id]
	, f.[property_tenancy_id]
	, f.[property_program_id]
	, f.[property_subprogram_id]
	, f.[property_tenancy_transaction_date_key]
	, f.[property_tenancy_transaction_rent_from_date_key]
	, f.[property_tenancy_transaction_rent_to_date_key]
	, f.[property_tenancy_transaction_rent_paid_to_date_key]
	, f.[property_tenancy_transaction_as_at_date_key]
	, f.[property_tenancy_transaction_name]
	, f.[property_tenancy_transaction_type_code]
	, f.[property_tenancy_transaction_type]
	, f.[property_tenancy_transaction_account_type]
	, f.[property_tenancy_transaction_subtransaction_name]
	, f.[property_tenancy_transaction_comments]
	, f.[property_tenancy_transaction_state]
	, f.[property_tenancy_transaction_status]
	, f.[property_tenancy_transaction_payment_type_id]
	, f.[property_tenancy_transaction_rent_nonrent]
	, f.[property_tenancy_transaction_credit_debit]
	, f.[property_tenancy_transaction_arrears_arrangement]
	, f.[property_tenancy_transaction_import_payment_name]
	, f.[property_tenancy_transaction_rent_generation_batch]
	, f.[property_tenancy_transaction_bc_entry_number]
	, f.[property_tenancy_transaction_amount]
	, f.[property_tenancy_transaction_balance_non_rent]
	, f.[property_tenancy_transaction_balance_rent]
	, f.[property_tenancy_transaction_balance_total]
	, f.[property_tenancy_transaction_receipt_number]
	, f.[property_tenancy_transaction_suspense_account_flag]
	, f.[property_tenancy_transaction_from_zavanti_import_flag]
	, f.[property_tenancy_transaction_created_datetime]
	, f.[property_tenancy_transaction_modified_datetime]
	, f.[property_tenancy_transaction_is_delete_flag]
	, f.[DWHBatchId]
	, f.[DWHCreatedAt]
	, f.[DWHModifiedOn]
	, f.[DWHDMLOperation]
	, f.[DWHSourceSystem]
    FROM [edw].[fact_property_tenancy_transaction] f
        LEFT JOIN [edw].[dim_property] dp ON f.[property_id] = dp.[property_id]
            AND dp.DWHIsCurrent = 1
        LEFT JOIN [edw].[dim_property_detail] dpd ON f.[property_id] = dpd.[property_detail_id]
            AND dpd.DWHIsCurrent = 1
        LEFT JOIN [edw].[dim_property_healthy_homes] dphh ON f.[property_id] = dphh.[property_healthy_homes_id]
            AND dphh.DWHIsCurrent = 1
        LEFT JOIN [edw].[dim_property_tenancy] dpt ON f.[property_tenancy_id] = dpt.[property_tenancy_id]
            AND dpt.DWHIsCurrent = 1
        LEFT JOIN [edw].[dim_property_program] dpp ON f.[property_program_id] = dpp.[property_program_id]
            AND f.[property_subprogram_id] = dpp.[property_subprogram_id]
            AND dpp.[DWHIsCurrent] = 1