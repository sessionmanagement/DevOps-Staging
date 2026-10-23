/**********************************************************************************************************
 Procedure	[edw].[Updateedw_row_level_security] 
 Author		Stefen Hasselberg
 Created	18/03/2024	
 Purpose	to provide a list of services or recordbase teams a user principal might have access too	
				

				
 Notes: Call By	EDW Pipeline [edw].[Updateedw_row_level_security]
	
 =========================================================================================================

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2024-03-18	  Stefen Hasselberg		Initial creation of stored procedure

**********************************************************************************************************/

CREATE PROCEDURE [edw].[Updateedw_row_level_security]

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Clean the table
    TRUNCATE TABLE edw.row_level_security

	-- insert data from staging into edw
	INSERT INTO [edw].[row_level_security](
		employee_number,
		employee_display_name,
		employee_email,
		job_title,
		employee_employment_status,
		manager_employee_number,
		manager_display_name,
		manager_job_title,
		manager_email,
		manager_employment_status,
		intellihr_business_unit_id,
		business_unit_name,
		intellihr_bc_code,
		intellihr_company_id,
		intellihr_company_name,
		dim_service_key,
		[recordbase_team_name],
		[recordbase_team_id],
		[recordbase_company_name],
		[dim_client_team_key]
		)
	SELECT 
		employee_number,
		employee_display_name,
		employee_email,
		job_title,
		employee_employment_status,
		manager_employee_number,
		manager_display_name,
		manager_job_title,
		manager_email,
		manager_employment_status,
		intellihr_business_unit_id,
		business_unit_name,
		intellihr_bc_code,
		intellihr_company_id,
		intellihr_company_name,
		dim_service_key,
		[recordbase_team_name],
        [recordbase_team_id],
        [recordbase_company_name],
        [dim_client_team_key]
	from staging.row_level_security


END