

CREATE VIEW [edw].[vw_dim_nationality]
AS
SELECT dim_nationality_key
	,nationality_id
	,nationality_name
      ,[DWHBatchId]
      ,[DWHCreatedAt]
      ,[DWHModifiedOn]
      ,[DWHDMLOperation]
      ,[DWHSourceSystem]
FROM [edw].[dim_nationality]