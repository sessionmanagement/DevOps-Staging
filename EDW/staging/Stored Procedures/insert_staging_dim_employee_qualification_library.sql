
CREATE PROC [staging].[insert_staging_dim_employee_qualification_library]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_employee_qualification_library]
PURPOSE:  

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-07-25    Greg Nuthall		Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_employee_qualification_library]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_employee_qualification_library] (
	 [employee_qualification_library_id] 
	,[employee_qualification_library] 
	,[job_requirement_usage_count] 
	)
SELECT
	 [employee_qualification_library_id] 
	,[employee_qualification_library] 
	,[job_requirement_usage_count] 
from [Landing].[edw_dim_employee_qualification_library]