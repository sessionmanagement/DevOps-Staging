

CREATE VIEW [edw].[vw_dim_gender]
AS
SELECT dim_gender_key
	,gender_id
	,gender_code
	,gender_name
	,intellihr_gender_key
	,datapay_gender_key
	,zavanti_gender_key
	,emplive_gender_key
      ,[DWHBatchId]
      ,[DWHCreatedAt]
      ,[DWHModifiedOn]
      ,[DWHDMLOperation]
      ,[DWHSourceSystem]
FROM [edw].[dim_gender]