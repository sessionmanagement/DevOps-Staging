
CREATE VIEW [edw].[vw_dim_district]
AS
SELECT dim_district_key
	,district_dimension_value_id
	,district_code
	,district_name
	,district_company_name
	,district_last_modified_date_time
	,DWHSourceSystem
	,DWHBatchId
	,DWHDMLOperation
	,DWHEffectiveFrom
	,DWHEffectiveTo
	,DWHIsCurrent
FROM [edw].[dim_district]