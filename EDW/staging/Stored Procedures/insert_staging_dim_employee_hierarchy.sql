



CREATE PROC [staging].[insert_staging_dim_employee_hierarchy]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_employee_hierarchy]
PURPOSE:  

NOTES: Call By EDW Pipeline '30_Load_From_ODS'

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 ?				?				Initial version
1.1		 2023-08-07	  Glenn McLeod		Updated to use table Framework table names 
1.1		 2023-08-21	  Glenn McLeod		Rename source tables
1.11	 2023-08-25	  Glenn McLeod		Updated table/column names
1.2		 2023-11-27	  Glenn McLeod		Added role hierarchy fields

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_employee_hierarchy]

-- insert data from landing table into staging table
INSERT INTO [staging].[ODSETLdim_employee_hierarchy] (
	[dim_employee_key]
	,[employee_id]
	,[employee_primary_email_address]
	,[employee_company_name]
	,[employee_Business_unit_name]
	,[employee_displayname]
	,[employee_people_leader_employee_number_level_1]
	,[employee_people_leader_email_level_1]
	,[employee_people_leader_business_unit_name_level_1]
	,[employee_people_leader_person_display_name_level_1]
	,[employee_people_leader_role_name_level_1]
	,[employee_people_leader_employee_number_level_2]
	,[employee_people_leader_email_level_2]
	,[employee_people_leader_business_unit_name_level_2]
	,[employee_people_leader_person_display_name_level_2]
	,[employee_people_leader_role_name_level_2]
	,[employee_people_leader_employee_number_level_3]
	,[employee_people_leader_email_level_3]
	,[employee_people_leader_business_unit_name_level_3]
	,[employee_people_leader_person_display_name_level_3]
	,[employee_people_leader_role_name_level_3]
	,[employee_people_leader_employee_number_level_4]
	,[employee_people_leader_email_level_4]
	,[employee_people_leader_business_unit_name_level_4]
	,[employee_people_leader_person_display_name_level_4]
	,[employee_people_leader_role_name_level_4]
	,[employee_people_leader_employee_number_level_5]
	,[employee_people_leader_email_level_5]
	,[employee_people_leader_business_unit_name_level_5]
	,[employee_people_leader_person_display_name_level_5]
	,[employee_people_leader_role_name_level_5]
	,[employee_people_leader_employee_number_level_6]
	,[employee_people_leader_email_level_6]
	,[employee_people_leader_business_unit_name_level_6]
	,[employee_people_leader_person_display_name_level_6]
	,[employee_people_leader_role_name_level_6]
	,[employee_people_leader_employee_number_level_7]
	,[employee_people_leader_email_level_7]
	,[employee_people_leader_business_unit_name_level_7]
	,[employee_people_leader_person_display_name_level_7]
	,[employee_people_leader_role_name_level_7]
	,[employee_people_leader_employee_number_level_8]
	,[employee_people_leader_email_level_8]
	,[employee_people_leader_business_unit_name_level_8]
	,[employee_people_leader_person_display_name_level_8]
	,[employee_people_leader_role_name_level_8]
	,[employee_people_leader_employee_number_level_9]
	,[employee_people_leader_email_level_9]
	,[employee_people_leader_business_unit_name_level_9]
	,[employee_people_leader_person_display_name_level_9]
	,[employee_people_leader_role_name_level_9]
	)
SELECT de.[dim_employee_key]
	,l.[StaffEmployeeNumber]
	,l.[StaffEmail]
	,l.[StaffbusinessEntity_name]
	,l.[StaffBusiness_unit_name]
	,l.StaffDisplayName
	,l.[L1Supervisor_EmployeeNumber]
	,l.[L1SupervisorEmail]
	,l.[L1_business_unit_name]
	,l.[L1SupervisorDisplayName]
	,l.[L1SupervisorRoleName]
	,l.[L2SupervisorPerson_EmployeeNumber]
	,l.[L2SupervisorEmail]
	,l.[L2business_unit_name]
	,l.[L2SupervisorDisplayName]
	,l.[L2SupervisorRoleName]
	,l.[L3SupervisorPerson_EmployeeNumber]
	,l.[L3SupervisorEmail]
	,l.[L3business_unit_name]
	,l.[L3SupervisorDisplayName]
	,l.[L3SupervisorRoleName]
	,l.[L4SupervisorPerson_EmployeeNumber]
	,l.[L4SupervisorEmail]
	,l.[L4business_unit_name]
	,l.[L4SupervisorDisplayName]
	,l.[L4SupervisorRoleName]
	,l.[L5SupervisorPerson_EmployeeNumber]
	,l.[L5SupervisorEmail]
	,l.[L5business_unit_name]
	,l.[L5SupervisorDisplayName]
	,l.[L5SupervisorRoleName]
	,l.[L6SupervisorPerson_EmployeeNumber]
	,l.[L6SupervisorEmail]
	,l.[L6business_unit_name]
	,l.[L6SupervisorDisplayName]
	,l.[L6SupervisorRoleName]
	,l.[L7SupervisorPerson_EmployeeNumber]
	,l.[L7SupervisorEmail]
	,l.[L7business_unit_name]
	,l.[L7SupervisorDisplayName]
	,l.[L7SupervisorRoleName]
	,l.[L8SupervisorPerson_EmployeeNumber]
	,l.[L8SupervisorEmail]
	,l.[L8business_unit_name]
	,l.[L8SupervisorDisplayName]
	,l.[L8SupervisorRoleName]
	,l.[L9SupervisorPerson_EmployeeNumber]
	,l.[L9SupervisorEmail]
	,l.[L9business_unit_name]
	,l.[L9SupervisorDisplayName]
	,l.[L9SupervisorRoleName]
FROM [landing].[edw_dim_employee_hierarchy] l
LEFT OUTER JOIN [edw].[dim_employee] de ON l.[StaffEmployeeNumber] = de.[employee_id]
	AND [DWHIsCurrent] = 1