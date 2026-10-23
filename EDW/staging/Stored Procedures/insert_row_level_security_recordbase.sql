
/**********************************************************************************************************
Procedure	[staging].[insert_row_level_security_recordbase]
Purpose	    Process Recordbase User and Team data to create a list of teams which a user has access to
			which is used for row level security
		
Notes: Call By	SP [staging].[insert_row_level_security]

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2024-03-26	  Stefen Hasselberg		Inital Creation


**********************************************************************************************************/


CREATE    PROCEDURE [staging].[insert_row_level_security_recordbase]

AS

BEGIN
	SET NOCOUNT ON;

	DECLARE @source_row_count INT
			, @target_row_count INT
	
-- Insert Recordbase security model
INSERT INTO staging.row_level_security (
	   [employee_number]
      ,[employee_display_name]
      ,[employee_email]
      ,[job_title]
      ,[manager_employee_number]
      ,[manager_display_name]
      ,[manager_job_title]
      ,[manager_email]
      ,[level_hierarchy]
	  , [recordbase_company_name]
      ,[recordbase_team_name]
      ,[recordbase_team_id]
	  )
SELECT 
	    [employee_number]
      , [employee_display_name]
      , [employee_email]
      , [job_title]
	  , [employee_number] as manager_employee_number
      , [employee_display_name] as manager_display_name
      , [job_title] as manager_job_title 
	  , [employee_email] as manager_email
	  , 50 as level_hierarchy
	  , [company_name]
      , [recordbase_team_name]
	  , [recordbase_team_id]
from landing.row_level_security_recordbase

SET @target_row_count = @@ROWCOUNT
SELECT @source_row_count =  COUNT(*) from landing.row_level_security_recordbase



-- Select return parameters as a dataset
select	@source_row_count	as source_row_count, @target_row_count as target_row_count

return;

END