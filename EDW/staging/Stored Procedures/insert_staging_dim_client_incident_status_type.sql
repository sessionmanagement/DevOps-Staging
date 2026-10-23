
CREATE PROC [staging].[insert_staging_dim_client_incident_status_type]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_client_incident_status_type]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-11-07    ?				Initial version
1.1		 2026-01-12	   Pankaj Bhatt		added composite key

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_client_incident_status_type]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_client_incident_status_type] (
	 [company_key_status_type_id]
	,[company_key] 
	,[incident_status_type_id] 
	,[incident_status_type_code] 
	,[incident_status_type_text] 
	,[incident_status_type_description] 
	,[incident_status_type_group] 
	)
SELECT
	 IIf(incident_status_type_id > 0, Cast(company_key As bigint) * 1000000000 + incident_status_type_id, incident_status_type_id)
	,[company_key] 
	,[incident_status_type_id] 
	,[incident_status_type_code] 
	,[incident_status_type_text] 
	,[incident_status_type_description] 
	,[incident_status_type_group] 
from [Landing].[edw_dim_client_incident_status_type]