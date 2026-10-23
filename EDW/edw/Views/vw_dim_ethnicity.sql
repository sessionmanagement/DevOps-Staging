

CREATE VIEW [edw].[vw_dim_ethnicity]
AS
SELECT dim_ethnicity_key
	,dim_ethnicity_id
	,ethnicity_group
	,ethnicity_level1
	,ethnicity_level2
	,ethnicity_level3
	,ethnicity_level4
	,ethnicity_level5
      ,[DWHBatchId]
      ,[DWHCreatedAt]
      ,[DWHModifiedOn]
      ,[DWHDMLOperation]
      ,[DWHSourceSystem]
FROM [edw].[dim_ethnicity]