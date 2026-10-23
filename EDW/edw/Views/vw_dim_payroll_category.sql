

CREATE VIEW [edw].[vw_dim_payroll_category]
AS
SELECT dim_payroll_category_key
	,payroll_category_id
	,payroll_category_name
	,payroll_category_short_name
	,payroll_category_add_to_duration_flag
	,payroll_category_hours_worked_flag
      ,[DWHBatchId]
      ,[DWHCreatedAt]
      ,[DWHModifiedOn]
      ,[DWHDMLOperation]
      ,[DWHSourceSystem]
FROM [edw].[dim_payroll_category]