


CREATE PROC [staging].[insert_staging_fact_client_incident_person]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_client_incident_person]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-11-27    Pankaj Bhatt		Initial version
1.1		 2026-01-13	   Pankaj Bhatt		added composite key

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_client_incident_person]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_client_incident_person] (
	 [dim_client_incident_company_key_incident_id_key]
	,[dim_company_key] 
	,[dim_client_incident_key]
	,[dim_client_key]
	,[incident_id] 
	,[client_id] 
	,[incident_client_entity_type] 
	,[incident_client_role] 
	)
SELECT
 	 isnull(dci.dim_client_incident_company_key_incident_id_key, CASE WHEN l.incident_id IS NOT NULL THEN -1 ELSE 0 END) AS dim_client_incident_company_key_incident_id_key
	,l.[company_key] as dim_company_key 
	,isnull(dci.dim_client_incident_key, CASE WHEN l.incident_id IS NOT NULL THEN -1 ELSE 0 END) AS dim_client_incident_key	
	,isnull(dc.dim_client_key, CASE WHEN l.client_id IS NOT NULL THEN -1 ELSE 0 END) AS dim_client_key	
	,l.[incident_id] 
	,l.[client_id] 
	,l.[incident_client_entity_type] 
	,l.[incident_client_role] 
from [Landing].[edw_fact_client_incident_person] l
left outer join edw.dim_client_incident dci on l.incident_id = dci.incident_id and l.company_key = dci.dim_company_key and dci.DWHIsCurrent = 1
left outer join edw.dim_client dc on l.company_key = dc.company_id and l.client_id = dc.client_id and dc.DWHIsCurrent = 1