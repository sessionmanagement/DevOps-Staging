
CREATE PROC [staging].[insert_staging_dim_employee_leave_request_type]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_employee_leave_request_type]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2026-03-02    Pankaj Bhatt		Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_employee_leave_request_type]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_employee_leave_request_type] (
	 [leave_request_type_id] 
	,[leave_request_type_code] 
	,[leave_request_type] 
	)
SELECT
	 [leave_request_type_id] 
	,[leave_request_type_code] 
	,[leave_request_type] 
from [Landing].[edw_dim_employee_leave_request_type]