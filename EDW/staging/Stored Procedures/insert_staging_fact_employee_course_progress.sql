CREATE proc [staging].[insert_staging_fact_employee_course_progress]

AS
/*************************************************************************************************
NAME:     [staging].[insert_staging_fact_employee_course_progress]
PURPOSE:  
NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2024-07-01    Manish Singh				Initial version
1.1      2024-07-18	   Manish singh				Tidy up some of columns based on review 
1.2      2024-08-06    Manish Singh				Adding 	[is_course_core_training_flag] flag
1.3		 2024-09-10	   Greg Nuthall				Use the mapping (reference.edw_lookup) to link mapped employees
1.4      2024-10-29    Manish Singh		        Add [is_course_linked_to_certification_flag] columns in ETL flow 
1.5      2024-11-18    Manish Singh             Join newly created view to get missing BU,postion name for missing akoranga records
1.6		 2025-01-07	   Greg Nuthall				Changed dim key null testing to allocate zero length strings as 0's not -1's
1.7		 2025-01-17	   Greg Nuthall				Added secondary service link to get the service when the company does not match 
1.8      2025-04-03    Manish Singh				Handling duplicate service and Business unit
1.9		 2025-04-11	   Greg Nuthall			    Removed second join to business unit for missing services
2.0      2025-05-05    Greg Nuthall			    Fixed service lookup link
2.1      2026-06-12    Greg Nuthall				Cater for employees who work across services and companies
******************************************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_employee_course_progress]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_employee_course_progress] (
	 [fact_employee_course_progress_id] 
	,dim_employee_key 
	,dim_service_key
	,dim_business_unit_hierarchy_key
	,dim_course_key
	 ,[employee_course_progress_user_id]
	,[employee_course_id] 
	,[employee_organisation_id] 
	 ,[employee_primary_company_name]
	,[employee_position_id] 
	,[employee_course_enrolled_date] 
	,[employee_course_started_date] 
	,[employee_course_completed_date] 
	,[employee_course_completion_percentage] 
	,[employee_course_renewal_status] 
	,[employee_course_due_date] 
	,[employee_position_name] 
	,[is_course_delivered_face_to_face_flag] 
	,[employee_course_completion_history_previous_completion] 
	,[employee_course_completion_grade] ,
	[is_course_core_training_flag] ,
	[is_course_linked_to_certification_flag]
)
SELECT
	[fact_employee_course_progress_id] 
	,isnull(de.[dim_employee_key],CASE WHEN isnull(employee_course_progress_user_id,'') <> '' THEN -1 ELSE 0 END) as dim_employee_key,
	isnull(isnull(isnull(ds.[dim_service_key],ds2.[dim_service_key]),ds3.[dim_service_key]),CASE WHEN isnull(employee_organisation_id,'') <> '' THEN -1 ELSE 0 END) as dim_service_key,
	isnull(buh.dim_business_unit_hierarchy_key,CASE WHEN isnull(employee_organisation_id,'') <> ''  THEN -1 ELSE 0 END) as dim_business_unit_hierarchy_key,
	isnull(dc.[dim_course_key],CASE WHEN isnull([employee_course_id],'') <> ''  THEN -1 ELSE 0 END) as dim_course_key
	,[employee_course_progress_user_id]
	,[employee_course_id] 
	,[employee_organisation_id] 
	,[employee_primary_company_name]
	,[employee_position_id] 
	,[employee_course_enrolled_date] 
	,[employee_course_started_date] 
	,[employee_course_completed_date] 
	,[employee_course_completion_percentage] 
	,[employee_course_renewal_status] 
	,[employee_course_due_date] 
	,[employee_position_name] 
	,[is_course_delivered_face_to_face_flag] 
	,[employee_course_completion_history_previous_completion] 
	,[employee_course_completion_grade] 
	,[is_course_core_training_flag] 
	,[is_course_linked_to_certification_flag]
	
	from [Landing].[edw_fact_employee_course_progress]
	left join reference.edw_lookup elk on cast([employee_course_progress_user_id] as nvarchar) = Cast(elk.Input_Value as nvarchar)
		and elk.Category = 'dim_employee.employee_id'
	left outer join [edw].[dim_employee] as de 
		on cast(isnull(elk.output_value,[employee_course_progress_user_id]) as nvarchar(100))=cast(de.[employee_id] as nvarchar(100)) 
		and de.DWHIsCurrent=1
	left outer join [edw].[dim_course] as dc 
		on cast([employee_course_id] as nvarchar(100))=cast(dc.course_id as nvarchar(100)) 
		and dc.DWHIsCurrent=1
	left outer join [edw].[vw_dim_business_unit_hierarchy_current] as buh 
		on cast(employee_organisation_id as nvarchar(100))=cast(buh.[business_unit_name] as nvarchar(100))
	left outer join reference.edw_lookup slk on Upper(trim(employee_organisation_id)) = Upper(trim(slk.Input_Value))
		and slk.Category = 'dim_service.service_code'
	left join reference.edw_lookup elk1 on Isnull([employee_primary_company_name],'Emerge Aotearoa') = elk1.Input_Value
		and elk1.Category = 'dim_employee.employee_company_name'
	left outer join [edw].[vw_dim_service_current] as ds
		on isnull(slk.output_value,employee_organisation_id)=ds.[service_name] and ds.DWHIsCurrent=1
		and isnull(elk1.Output_Value,[employee_primary_company_name])=ds.company_name
	
	--This deals with people who work for many services and the process has assigned a company  
	left outer join [edw].[vw_dim_service_current] as ds2
		on employee_organisation_id=ds2.[service_name] and ds2.DWHIsCurrent=1
		and [employee_primary_company_name] = 'Mind & Body'
		and ds2.dim_company_key = 1
	left outer join [edw].[vw_dim_service_current] as ds3
		on employee_organisation_id=ds3.[service_name] and ds3.DWHIsCurrent=1
		and isnull([employee_primary_company_name],'Emerge Aotearoa') = 'Emerge Aotearoa'
		and ds3.dim_company_key = 5