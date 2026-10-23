
CREATE VIEW [edw].[vw_dim_location]
AS
SELECT dim_location_key
	,location_dimension_value_id
	,location_code
	,location_name
	,location_company_name
	,location_last_modified_date_time
	,DWHSourceSystem
	,DWHBatchId
	,DWHDMLOperation
	,DWHEffectiveFrom
	,DWHEffectiveTo
	,DWHIsCurrent
FROM [edw].[dim_location]