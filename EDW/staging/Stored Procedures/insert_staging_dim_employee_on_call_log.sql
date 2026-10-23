CREATE PROC [staging].[insert_staging_dim_employee_on_call_log]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_employee_on_call_log]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2026-08-11    ?				Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_employee_on_call_log]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_employee_on_call_log] (
	 [on_call_id] 	,[on_call_title] 	,[event_name] 	,[call_received_from] 	,[issue_description] 	,[outcome] 	,[escalation_comments] 
	)
SELECT
	 [on_call_id] 	,[on_call_title] 	,[event_name] 	,[call_received_from] 	,[issue_description] 	,[outcome] 	,[escalation_comments] 
from [Landing].[edw_dim_employee_on_call_log]