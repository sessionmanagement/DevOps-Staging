

CREATE PROC [staging].[insert_staging_dim_employee_incident_classification]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_employee_incident_classification]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2026-01-22    Pankaj Bhatt		Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_employee_incident_classification]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_employee_incident_classification] (
	 [dim_employee_incident_id_key]
	,[incident_id] 
	,[incident_classification_level1_code] 
	,[incident_classification_level1_name] 
	,[incident_classification_level2_code] 
	,[incident_classification_level2_name] 
	,[incident_classification_level3_code] 
	,[incident_classification_level3_name] 
	,[incident_classification_notes] 
	)
SELECT
	 [incident_id]
	,[incident_id] 
	,[incident_classification_level1_code] 
	,[incident_classification_level1_name] 
	,[incident_classification_level2_code] 
	,[incident_classification_level2_name] 
	,[incident_classification_level3_code] 
	,[incident_classification_level3_name] 
	,[incident_classification_notes] 
from [Landing].[edw_dim_employee_incident_classification]