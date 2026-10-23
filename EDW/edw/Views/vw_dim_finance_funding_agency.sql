
CREATE VIEW [edw].[vw_dim_finance_funding_agency]
AS
SELECT dim_finance_funding_agency_key
	,finance_funding_agency_dimension_value_id
	,finance_funding_agency_code
	,finance_funding_agency_name
	,finance_funding_agency_company_name
	,finance_funding_agency_last_modified_date_time
	,DWHSourceSystem
	,DWHBatchId
	,DWHDMLOperation
	,DWHEffectiveFrom
	,DWHEffectiveTo
	,DWHIsCurrent
FROM [edw].[dim_finance_funding_agency]