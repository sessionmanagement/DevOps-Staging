
CREATE VIEW [edw].[vw_dim_finance_customer]
AS
SELECT dim_finance_customer_key
	,finance_customer_dimension_value_id
	,finance_customer_code
	,finance_customer_name
	,finance_customer_company_name
	,finance_customer_last_modified_date_time
	,DWHSourceSystem
	,DWHBatchId
	,DWHDMLOperation
	,DWHEffectiveFrom
	,DWHEffectiveTo
	,DWHIsCurrent
FROM [edw].[dim_finance_customer]