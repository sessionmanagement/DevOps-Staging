
CREATE VIEW [edw].[vw_dim_finance_vendor]
AS
SELECT dim_finance_vendor_key
	,finance_vendor_dimension_value_id
	,finance_vendor_code
	,finance_vendor_name
	,finance_vendor_company_name
	,finance_vendor_last_modified_date_time
	,DWHSourceSystem
	,DWHBatchId
	,DWHDMLOperation
	,DWHEffectiveFrom
	,DWHEffectiveTo
	,DWHIsCurrent
FROM [edw].[dim_finance_vendor]