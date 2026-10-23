
CREATE VIEW [edw].[vw_dim_finance_funder]
AS
SELECT dim_finance_funder_key
	,finance_funder_dimension_value_id
	,finance_funder_code
	,finance_funder_name
	,finance_funder_company_name
	,finance_funder_last_modified_date_time
	,DWHSourceSystem
	,DWHBatchId
	,DWHDMLOperation
	,DWHEffectiveFrom
	,DWHEffectiveTo
	,DWHIsCurrent
FROM [edw].[dim_finance_funder]