
CREATE VIEW [edw].[vw_dim_department]
AS
SELECT dim_department_key
	,department_dimension_value_id
	,department_code
	,department_name
	,department_company_name
	,department_last_modified_date_time
	,DWHSourceSystem
	,DWHBatchId
	,DWHDMLOperation
	,DWHEffectiveFrom
	,DWHEffectiveTo
	,DWHIsCurrent
FROM [edw].[dim_department]