
CREATE VIEW [edw].[vw_dim_region]
AS
SELECT dim_region_key
	,region_dimension_value_id
	,region_code
	,region_name
	,region_company_name
	,region_last_modified_date_time
	,DWHSourceSystem
	,DWHBatchId
	,DWHDMLOperation
	,DWHEffectiveFrom
	,DWHEffectiveTo
	,DWHIsCurrent
FROM [edw].[dim_region]