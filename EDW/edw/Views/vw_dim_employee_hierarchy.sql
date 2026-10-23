


CREATE VIEW [edw].[vw_dim_employee_hierarchy]

/**********************************************************************************************************
 View      [edw].[vw_dim_employee_hierarchy] 
 Purpose   Build the edw.vw_dim_employee_hierarchy view 

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2023-08-22	   Glenn McLeod			Initial creation of stored procedure
1.1     2026-09-10     Greg Nuthall         Removed PII data columns
 **********************************************************************************************************/

AS
SELECT dim_employee_hierarchy_key
	,dim_employee_key
	,employee_id
	,employee_primary_email_address
	,employee_company_name
	,employee_Business_unit_name
	,employee_displayname
	,null as employee_people_leader_employee_number_level_1
	,'' as employee_people_leader_email_level_1
	,employee_people_leader_business_unit_name_level_1
	,employee_people_leader_person_display_name_level_1
	,null as employee_people_leader_employee_number_level_2
	,'' as employee_people_leader_email_level_2
	,employee_people_leader_business_unit_name_level_2
	,employee_people_leader_person_display_name_level_2
	,null as employee_people_leader_employee_number_level_3
	,'' as employee_people_leader_email_level_3
	,employee_people_leader_business_unit_name_level_3
	,employee_people_leader_person_display_name_level_3
	,null as employee_people_leader_employee_number_level_4
	,'' as employee_people_leader_email_level_4
	,employee_people_leader_business_unit_name_level_4
	,employee_people_leader_person_display_name_level_4
	,null as employee_people_leader_employee_number_level_5
	,'' as employee_people_leader_email_level_5
	,employee_people_leader_business_unit_name_level_5
	,employee_people_leader_person_display_name_level_5
	,null as employee_people_leader_employee_number_level_6
	,'' as employee_people_leader_email_level_6
	,employee_people_leader_business_unit_name_level_6
	,employee_people_leader_person_display_name_level_6
	,null as employee_people_leader_employee_number_level_7
	,'' as employee_people_leader_email_level_7
	,employee_people_leader_business_unit_name_level_7
	,employee_people_leader_person_display_name_level_7
	,null as employee_people_leader_employee_number_level_8
	,'' as employee_people_leader_email_level_8
	,employee_people_leader_business_unit_name_level_8
	,employee_people_leader_person_display_name_level_8
	,null as employee_people_leader_employee_number_level_9
	,'' as employee_people_leader_email_level_9
	,employee_people_leader_business_unit_name_level_9
	,employee_people_leader_person_display_name_level_9
	,DWHSourceSystem
	,DWHBatchId
	,DWHDMLOperation
	,DWHEffectiveFrom
	,DWHEffectiveTo
	,DWHIsCurrent
	,employee_people_leader_role_name_level_1
	,employee_people_leader_role_name_level_2
	,employee_people_leader_role_name_level_3
	,employee_people_leader_role_name_level_4
	,employee_people_leader_role_name_level_5
	,employee_people_leader_role_name_level_6
	,employee_people_leader_role_name_level_7
	,employee_people_leader_role_name_level_8
	,employee_people_leader_role_name_level_9
FROM [edw].[dim_employee_hierarchy]