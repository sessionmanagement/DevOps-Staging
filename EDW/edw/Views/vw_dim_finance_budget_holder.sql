
CREATE VIEW [edw].[vw_dim_finance_budget_holder]
AS
SELECT dim_finance_budget_holder_key
	,finance_budget_holder_dimension_value_id
	,finance_budget_holder_code
	,finance_budget_holder_name
	,finance_budget_holder_company_name
	,finance_budget_holder_last_modified_date_time
	,DWHSourceSystem
	,DWHBatchId
	,DWHDMLOperation
	,DWHEffectiveFrom
	,DWHEffectiveTo
	,DWHIsCurrent
FROM [edw].[dim_finance_budget_holder]