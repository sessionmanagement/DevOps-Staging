
CREATE VIEW [edw].[vw_dim_finance_contract]
AS
SELECT dim_finance_contract_key
	,finance_contract_dimension_value_id
	,finance_contract_code
	,finance_contract_name
	,finance_contract_company_name
	,finance_contract_last_modified_date_time
	,DWHSourceSystem
	,DWHBatchId
	,DWHDMLOperation
	,DWHEffectiveFrom
	,DWHEffectiveTo
	,DWHIsCurrent
FROM [edw].[dim_finance_contract]