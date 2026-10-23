


/****** Object:  View [ETL].[dim_client_incident_severity]    Script Date: 5/11/2025 10:28:18 am ******/
CREATE     view [ETL].[dim_client_incident_severity]

as

/**********************************************************************************************************
 View		[ETL].[dim_client_incident_severity]
 Author		Pankaj Bhatt
 Created	2025-10-31
 Purpose	Used to build the edw.dim_client_incident_severity table 

 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2025-10-31		Pankaj Bhatt	Initial version

**************************************************************************************************************/

SELECT 
	1 AS company_key
	,isev.IncidentSeverityID as incident_severity_id
    ,isev.IncidentSeverityValue as incident_severity_value
    ,isev.IncidentSeverityText as incident_severity_text
	,isev.IncidentSeverityIsActive as is_incident_severity_active
FROM RBEAL.dlDimIncidentSeverity isev
union all
SELECT distinct
	5 AS company_key
	,isev.IncidentSeverityID as incident_severity_id
    ,isev.IncidentSeverityValue as incident_severity_value
    ,isev.IncidentSeverityText as incident_severity_text
	,isev.IncidentSeverityIsActive as is_incident_severity_active
FROM RBMNB.dlDimIncidentSeverity isev