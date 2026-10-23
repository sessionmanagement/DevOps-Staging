



/****** Object:  View [ETL].[dim_client_incident_status_type]    Script Date: 5/11/2025 10:27:57 am ******/
/****** Object:  View [ETL].[dim_client_incident_status_type]    Script Date: 31/10/2025 10:30:53 am ******/
CREATE          view [ETL].[dim_client_incident_status_type]

as

/**********************************************************************************************************
 View		[ETL].[dim_client_incident_status_type]
 Author		Pankaj Bhatt
 Created	2025-10-31
 Purpose	Used to build the edw.dim_client_incident_status_type table 

 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2025-10-31		Pankaj Bhatt	Initial version

**************************************************************************************************************/

SELECT 
	1 AS company_key
	,ist.IncidentStatusTypeID as incident_status_type_id
    ,ist.IncidentStatusTypeCode as incident_status_type_code
    ,ist.IncidentStatusTypeText as incident_status_type_text
	,ist.IncidentStatusTypeDescription as incident_status_type_description
	,ist.IncidentStatusTypeGroup as incident_status_type_group
FROM RBEAL.dlDimIncidentStatusType ist
union all
SELECT distinct
	5 AS company_key
	,ist.IncidentStatusTypeID as incident_status_type_id
    ,ist.IncidentStatusTypeCode as incident_status_type_code
    ,ist.IncidentStatusTypeText as incident_status_type_text
	,ist.IncidentStatusTypeDescription as incident_status_type_description
	,ist.IncidentStatusTypeGroup as incident_status_type_group
FROM RBMNB.dlDimIncidentStatusType ist