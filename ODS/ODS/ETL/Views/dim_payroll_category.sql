

CREATE  VIEW [ETL].[dim_payroll_category]

AS

SELECT tc.[id] AS payroll_category_id
      ,CAST(tc.[name] AS VARCHAR(50)) AS payroll_category_name
      ,CAST(tc.[abbreviation] AS VARCHAR(50)) AS payroll_category_short_name
      --,tc.[comments]
      ,tc.[add_to_duration] AS payroll_category_add_to_duration_flag
	,CAST(CASE 
			WHEN (
					tc.NAME LIKE '%leave%'
					OR tc.NAME LIKE '%holiday%'
					)
				OR tc.add_to_duration = 0
				THEN 0
			ELSE 1
			END AS INT) AS payroll_category_hours_worked_flag 
  FROM [EmpLive].[time_categories] tc
  where tc.ODSIsCurrent = 1