






CREATE PROC [staging].[insert_staging_fact_employee_program_progress]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_employee_program_progress]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2024-07-04    Manish Singh				Initial version
2.0      2024-09-05    Manish Singh				Cast employee_id to nvarchar 
2.1		 2024-09-10	   Greg Nuthall				Use the mapping (reference.edw_lookup) to link mapped employees
3.0      2024-11-18    Manish Singh            Join newly created view to get missing BU,postion name for missing akoranga records
4.1      2025-04-03    Manish Singh				Handling duplicate service and Business unit
****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_employee_program_progress]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_employee_program_progress] (
	 [fact_employee_program_progress_id] 
	 ,dim_employee_key 
	,dim_service_key
	,dim_business_unit_hierarchy_key
	,dim_program_key
      ,[employee_organisation_id]
	   ,[employee_primary_company_name]
      ,[employee_position_id]
      ,[employee_program_id]
      ,[employee_program_progress_user_id]
      ,[employee_course_set_id]
      ,[employee_program_status]
      ,[employee_program_started_date]
      ,[employee_program_due_date]
      ,[employee_program_completed_date]
      ,[employee_program_created_date]
      ,[employee_position_name]
      ,[employee_context_level]
      ,[employee_program_path]
      ,[employee_program_depth]
      ,[employee_parent_program_id]
      ,[employee_program_assigned_date]
      ,[employee_program_exception_status]
      ,[is_program_delivered_face_to_face_flag]
	)
SELECT
	 [fact_employee_program_progress_id] 
	 		  ,isnull(de.[dim_employee_key],CASE WHEN employee_program_progress_user_id IS NOT NULL THEN -1 ELSE 0 END) as dim_employee_key,
			  isnull(ds.[dim_service_key],CASE WHEN employee_organisation_id IS NOT NULL THEN -1 ELSE 0 END) as dim_service_key,
			  isnull(buh.dim_business_unit_hierarchy_key,CASE WHEN employee_organisation_id IS NOT NULL THEN -1 ELSE 0 END) as dim_business_unit_hierarchy_key,
			   isnull(dm.[dim_program_key],CASE WHEN [employee_program_progress_user_id] IS NOT NULL THEN -1 ELSE 0 END) as dim_program_key
      ,[employee_organisation_id]
	   ,[employee_primary_company_name]
      ,[employee_position_id]
      ,[employee_program_id]
      ,[employee_program_progress_user_id]
      ,[employee_course_set_id]
      ,[employee_program_status]
      ,[employee_program_started_date]
      ,[employee_program_due_date]
      ,[employee_program_completed_date]
      ,[employee_program_created_date]
      ,[employee_position_name]
      ,[employee_context_level]
      ,[employee_program_path]
      ,[employee_program_depth]
      ,[employee_parent_program_id]
      ,[employee_program_assigned_date]
      ,[employee_program_exception_status]
      ,[is_program_delivered_face_to_face_flag] 
from [Landing].[edw_fact_employee_program_progress]
left join reference.edw_lookup elk on cast(employee_program_progress_user_id as nvarchar) = Cast(elk.Input_Value as nvarchar)
					and elk.Category = 'dim_employee.employee_id'
left outer join [edw].[dim_employee] as de on isnull(elk.Output_Value,employee_program_progress_user_id)=cast(de.[employee_id] as nvarchar)and de.DWHIsCurrent=1
left join reference.edw_lookup elk1 on [employee_primary_company_name] = elk1.Input_Value
					and elk1.Category = 'dim_employee.employee_company_name'
--left outer join [edw].[dim_employee] as de on  cast([employee_program_progress_user_id] as nvarchar(100))=cast(de.[employee_id] as nvarchar(100)) and de.DWHIsCurrent=1
left outer join [edw].[dim_program] as dm on [employee_program_id]=dm.program_id and dm.DWHIsCurrent=1
left outer join [edw].[vw_dim_business_unit_hierarchy_current] as buh on cast(employee_organisation_id as nvarchar(100))=cast(buh.[business_unit_name]  as nvarchar(100))
left outer join [edw].[vw_dim_service_current] as ds on employee_organisation_id=ds.[service_name] and ds.DWHIsCurrent=1 and elk1.Output_Value=ds.company_name