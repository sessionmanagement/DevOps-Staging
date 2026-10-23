

CREATE VIEW [edw].[vw_dim_leave_type]
AS
SELECT dim_leave_type_key
	,leave_type_id
	,leave_type_name
	,leave_type_group
	,leave_type_company_name
      ,[DWHBatchId]
      ,[DWHCreatedAt]
      ,[DWHModifiedOn]
      ,[DWHDMLOperation]
      ,[DWHSourceSystem]
FROM [edw].[dim_leave_type]