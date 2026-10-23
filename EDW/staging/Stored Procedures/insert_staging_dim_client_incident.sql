
CREATE PROC [staging].[insert_staging_dim_client_incident]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_client_incident]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-11-06    ?				Initial version
1.1		 2026-01-12	   Pankaj Bhatt		added composite key

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_client_incident]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_client_incident] (
	 [company_key_incident_id]
	,[company_key] 
	,[incident_id] 
	,[incident_date] 
	,[incident_title] 
	,[incident_description] 
	,[incident_location] 
	,[incident_immediate_action_taken] 
	,[incident_possible_prevention] 
	,[incident_further_action_required] 
	,[incident_investigation_details] 
	,[incident_created_date] 
	,[incident_outcome_details] 
	)
SELECT
	 IIf(incident_id > 0, Cast(company_key As bigint) * 1000000000 + incident_id, incident_id)
	,[company_key] 
	,[incident_id] 
	,[incident_date] 
	,[incident_title] 
	,[incident_description] 
	,[incident_location] 
	,[incident_immediate_action_taken] 
	,[incident_possible_prevention] 
	,[incident_further_action_required] 
	,[incident_investigation_details] 
	,[incident_created_date] 
	,[incident_outcome_details] 
from [Landing].[edw_dim_client_incident]