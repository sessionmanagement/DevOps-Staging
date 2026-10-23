

CREATE VIEW [edw].[vw_dim_age_group]
AS
SELECT dim_age_group_key
	,age_in_years
	,age_group_tangatawhaiora
	,age_5_Year_Groups
	,age_decade_Group
	,age_Group_Broad
	,age_Group_MoH_Covid
	,age_group_groupings
	,DWHSourceSystem
	,DWHCreatedAt
	,DWHBatchId
FROM [edw].[dim_age_group]