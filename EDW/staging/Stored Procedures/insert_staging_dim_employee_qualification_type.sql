CREATE PROC [staging].[insert_staging_dim_employee_qualification_type]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_employee_qualification_type]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-07-25    ?				Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_employee_qualification_type]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_employee_qualification_type] (
	 [employee_qualification_type_id] 	,[employee_qualification_type] 
	)
SELECT
	 [employee_qualification_type_id] 	,[employee_qualification_type] 
from [Landing].[edw_dim_employee_qualification_type]