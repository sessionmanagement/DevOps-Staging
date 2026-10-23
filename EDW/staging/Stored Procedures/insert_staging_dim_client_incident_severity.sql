


CREATE PROC [staging].[insert_staging_dim_client_incident_severity]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_client_incident_severity]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-11-06    ?				Initial version
1.1		 2026-01-12	   Pankaj Bhatt		added composite key

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_client_incident_severity]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_client_incident_severity] (
	company_key_severity_id
	,[company_key] 
	,[incident_severity_id] 
	,[incident_severity_value] 
	,[incident_severity_text] 
	,[is_incident_severity_active] 
	)
SELECT
	IIf(incident_severity_id > 0, Cast(company_key As bigint) * 1000000000 + incident_severity_id, incident_severity_id)
	,[company_key] 
	,[incident_severity_id] 
	,[incident_severity_value] 
	,[incident_severity_text] 
	,[is_incident_severity_active] 
from [Landing].[edw_dim_client_incident_severity]