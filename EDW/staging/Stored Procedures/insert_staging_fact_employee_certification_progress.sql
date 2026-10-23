







CREATE PROC [staging].[insert_staging_fact_employee_certification_progress]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_employee_certification_progress]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2024-07-05    Manish Singh				Initial version
2.0      2024-07-10    Manish Singh             changed column name and datatype as per new findings
3.0      2024-08-21    Manish Singh				Changed flag column name by putting "flag" postfix
3.1		 2024-09-10	   Greg Nuthall				Use the mapping (reference.edw_lookup) to link mapped employees
4.0      2024-10-10    Manish Singh	            Added assigned date columns in table 
5.0      2024-11-18    Manish Singh			    Adding [employee_primary_company_name] in stored proc
5.1		 2025-01-07	   Greg Nuthall				Changed dim key null testing to allocate zero length strings as 0's not -1's
6.1      2025-04-03    Manish Singh				Handling duplicate service and Business unit
6.2		 2025-05-05    Greg Nuthall				Added link to reference table to lookup services
**************************************************************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_employee_certification_progress]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_employee_certification_progress] (
       
	   [fact_employee_certification_progress_id] 
	   ,dim_employee_key
	   ,dim_service_key
	   ,dim_business_unit_hierarchy_key
	   ,dim_certification_key
      ,[employee_organisation_id]
	  ,[employee_primary_company_name]
      ,[employee_position_id]
      ,[employee_certification_progress_user_id]
      ,[employee_course_set_id]
      ,[employee_certification_status]
      ,[is_recertification]
      ,[is_unassigned_to_employee_flag]
	  ,[employee_certification_assigned_date]
      ,[employee_certification_due_date]
      ,[employee_certification_expiry_date]
      ,[employee_certification_window_opens_date]
      ,[employee_certification_completed_date]
      ,[employee_certification_renewal_status]
      ,[employee_certification_completion_history_link]
      ,[employee_certification_id]
      ,[employee_certification_completed_history_date]
      ,[employee_context_level]
      ,[employee_certification_path]
      ,[employee_certification_depth]
      ,[employee_parent_certification_id]
      ,[employee_position_name]
      ,[is_cerification_delivered_face_to_face_flag]
	)
SELECT [fact_employee_certification_progress_id]
	       [fact_employee_course_progress_id] 
		  ,isnull(de.[dim_employee_key],CASE WHEN isnull([employee_certification_progress_user_id],'') <> ''  THEN -1 ELSE 0 END) as dim_employee_key,
			  isnull(ds.[dim_service_key],CASE WHEN isnull(employee_organisation_id,'') <> ''  THEN -1 ELSE 0 END) as dim_service_key,
			  isnull(buh.dim_business_unit_hierarchy_key,CASE WHEN isnull(employee_organisation_id,'') <> ''  THEN -1 ELSE 0 END) as dim_business_unit_hierarchy_key,
			   isnull(dc.[dim_certification_key],CASE WHEN isnull([employee_certification_id],'') <> ''  THEN -1 ELSE 0 END) as dim_certification_key
      ,[employee_organisation_id]
	  	,[employee_primary_company_name]
      ,[employee_position_id]
      ,[employee_certification_progress_user_id]
      ,[employee_course_set_id]
      ,[employee_certification_status]
      ,[is_recertification]
      ,[is_unassigned_to_employee_flag]
	   ,[employee_certification_assigned_date]
      ,[employee_certification_due_date]
      ,[employee_certification_expiry_date]
      ,[employee_certification_window_opens_date]
      ,[employee_certification_completed_date]
      ,[employee_certification_renewal_status]
      ,[employee_certification_completion_history_link]
      ,[employee_certification_id]
      ,[employee_certification_completed_history_date]
      ,[employee_context_level]
      ,[employee_certification_path]
      ,[employee_certification_depth]
      ,[employee_parent_certification_id]
      ,[employee_position_name]
      ,[is_cerification_delivered_face_to_face_flag]
  FROM [landing].[edw_fact_employee_certification_progress]
  left join reference.edw_lookup elk on cast([employee_certification_progress_user_id] as nvarchar) = Cast(elk.Input_Value as nvarchar)
					and elk.Category = 'dim_employee.employee_id'
  left outer join [edw].[dim_employee] as de on isnull(elk.Output_Value,[employee_certification_progress_user_id])=cast(de.[employee_id] as nvarchar) and de.DWHIsCurrent=1
     left join reference.edw_lookup elk1 on [employee_primary_company_name] = elk1.Input_Value
					and elk1.Category = 'dim_employee.employee_company_name'
	left outer join [edw].[dim_certification] as dc on [employee_certification_id]=dc.certification_id and dc.DWHIsCurrent=1
	left outer join [edw].[vw_dim_business_unit_hierarchy_current] as buh on cast(employee_organisation_id as nvarchar(100))=cast(buh.[business_unit_name]  as nvarchar(100))
	left outer join reference.edw_lookup slk on employee_organisation_id = Cast(slk.Input_Value as nvarchar)
						and slk.Category = 'dim_service.service_code'
	left outer join [edw].[vw_dim_service_current] as ds 
				on isnull(slk.output_value,employee_organisation_id)=ds.[service_name] 
				and  ds.DWHIsCurrent=1 
				and isnull(elk1.Output_Value, [employee_primary_company_name])=ds.company_name