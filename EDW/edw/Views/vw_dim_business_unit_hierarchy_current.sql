



CREATE VIEW [edw].[vw_dim_business_unit_hierarchy_current]
AS
SELECT dim_business_unit_hierarchy_key
	,business_unit_id
	,business_unit_name
	,business_unit_hierarchy_level1_id
	,business_unit_hierarchy_level1_name
	,business_unit_hierarchy_level2_id
	,business_unit_hierarchy_level2_name
	,business_unit_hierarchy_level3_id
	,business_unit_hierarchy_level3_name
	,business_unit_hierarchy_level4_id
	,business_unit_hierarchy_level4_name
	,business_unit_hierarchy_level5_id
	,business_unit_hierarchy_level5_name
	,business_unit_hierarchy_level6_id
	,business_unit_hierarchy_level6_name
	,business_unit_hierarchy_level7_id
	,business_unit_hierarchy_level7_name
	,business_unit_concatenated_hierarchy
	,is_active_flag
      ,[DWHBatchId]
      ,[DWHCreatedAt]
      ,[DWHModifiedOn]
      ,[DWHDMLOperation]
      ,[DWHSourceSystem]  from (

  SELECT 
*,
        RANK() OVER (PARTITION BY business_unit_name ORDER BY dim_business_unit_hierarchy_key DESC) AS rn
FROM [edw].[dim_business_unit_hierarchy] 
) t
WHERE rn = 1;