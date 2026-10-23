
CREATE PROC [staging].[insert_staging_dim_payroll_category]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_payroll_category]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2023-12-18    Glenn McLeod		Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_payroll_category]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_payroll_category] (
	 [payroll_category_id] 
	,[payroll_category_name] 
	,[payroll_category_short_name] 
	,[payroll_category_add_to_duration_flag] 
	,[payroll_category_hours_worked_flag] 
	)
SELECT
	 [payroll_category_id] 
	,[payroll_category_name] 
	,[payroll_category_short_name] 
	,[payroll_category_add_to_duration_flag] 
	,[payroll_category_hours_worked_flag] 
from [Landing].[edw_dim_payroll_category]