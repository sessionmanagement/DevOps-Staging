






CREATE PROC [staging].[insert_staging_fact_client_incident_category]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_client_incident_category]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-11-17    Pankaj Bhatt		Initial version
1.1		 2026-01-13	   Pankaj Bhatt		added composite key

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_client_incident_category]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_client_incident_category] (
	 [dim_client_incident_company_key_incident_id_key]
	,[dim_client_incident_company_key_category_type_id_key]
	,[dim_company_key]
	,[dim_client_incident_key]
	,[dim_client_incident_category_type_key]
	,[incident_id] 
	,[incident_category_type_id] 
	,[incident_category_created_date] 
	)
SELECT
	 isnull(dci.dim_client_incident_company_key_incident_id_key, CASE WHEN l.incident_id IS NOT NULL THEN -1 ELSE 0 END) AS dim_client_incident_company_key_incident_id_key
	,IIf(l.incident_category_type_id > 0, Cast(l.company_key As bigint) * 1000000000 + l.incident_category_type_id, l.incident_category_type_id) AS dim_client_incident_company_key_category_type_id_key
	,l.[company_key] as dim_company_key
	,isnull(dci.dim_client_incident_key, CASE WHEN l.incident_id IS NOT NULL THEN -1 ELSE 0 END) AS dim_client_incident_key
	,isnull(dcict.dim_client_incident_category_type_key, CASE WHEN l.incident_category_type_id IS NOT NULL THEN -1 ELSE 0 END) AS dim_client_incident_category_type_key
    
	,l.[incident_id] 
	,l.[incident_category_type_id] 
	,l.[incident_category_created_date] 
from [Landing].[edw_fact_client_incident_category] l
left outer join edw.dim_client_incident dci on l.incident_id = dci.incident_id and l.company_key = dci.dim_company_key and dci.DWHIsCurrent = 1
left outer join edw.dim_client_incident_category_type dcict on l.incident_category_type_id = dcict.incident_category_type_id and l.company_key = dcict.dim_company_key and dcict.DWHIsCurrent = 1