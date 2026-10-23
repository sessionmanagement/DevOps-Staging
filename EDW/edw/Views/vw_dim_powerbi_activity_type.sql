
CREATE VIEW [edw].[vw_dim_powerbi_activity_type]
AS
SELECT dim_powerbi_activity_type_key
	,activity
	,activity_group
	,activity_description
	,activity_notes
	,DWHBatchId
	,DWHEffectiveFrom
	,DWHEffectiveTo
	,DWHDMLOperation
	,DWHIsCurrent
	,DWHSourceSystem
FROM [edw].[dim_powerbi_activity_type]