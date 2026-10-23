
CREATE VIEW [edw].[vw_fact_finance_budget]
AS
SELECT fact_finance_budget_key
	,dim_finance_general_ledger_account_key
	,dim_finance_budget_holder_key
	,dim_finance_contract_key
	,dim_finance_customer_key
	,dim_department_key
	,dim_district_key
	,dim_finance_funder_key
	,dim_finance_funding_agency_key
	,dim_location_key
	,dim_region_key
	,dim_service_key
	,dim_finance_vendor_key
	,dim_company_key
	,fact_finance_budget_partition_key
	,fact_finance_budget_row_key
	,finance_budget_holder_id
	,finance_contract_id
	,finance_customer_id
	,department_id
	,district_id
	,finance_funder_id
	,finance_funding_agency_id
	,location_id
	,region_id
	,service_id
	,finance_vendor_id
	,finance_budget_company_name
	,finance_budget_general_ledger_account_no
	,finance_budget_dimension_set_id
	,finance_budget_budget_name
	,finance_budget_description
	,finance_budget_global_dimension_1_code
	,finance_budget_entry_no
	,finance_budget_date_key
	,finance_budget_last_modified_date_time
	,finance_budget_amount
	,DWHSourceSystem
	,DWHBatchId
	,DWHDMLOperation
	,DWHModifiedOn
	,DWHCreatedAt
FROM [edw].[fact_finance_budget]