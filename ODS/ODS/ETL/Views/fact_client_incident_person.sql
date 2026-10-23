

CREATE          view [ETL].[fact_client_incident_person]

as

/**********************************************************************************************************
 View		[ETL].[fact_client_incident_person]
 Author		Pankaj Bhatt
 Created	2025-11-27
 Purpose	Used to build the edw.fact_client_incident_person table 

 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2025-11-27		Pankaj Bhatt	Initial version
**************************************************************************************************************/


SELECT 
-- distinct as table has the same client multiple times
     distinct
	 1 AS company_key
    ,fip.IncidentID as incident_id
    ,fip.EntityID as client_id
    ,fip.IncidentPersonEntityType as incident_client_entity_type
    ,fip.IncidentPersonRole as incident_client_role
FROM RBEAL.dlFactIncidentPerson fip
where fip.IncidentPersonEntityType = 'Person'
union all
SELECT 
    distinct
	5 AS company_key
    ,fip.IncidentID as incident_id
    ,fip.EntityID as client_id
    ,fip.IncidentPersonEntityType as incident_client_entity_type
    ,fip.IncidentPersonRole as incident_client_role
FROM RBMNB.dlFactIncidentPerson fip
where fip.IncidentPersonEntityType = 'Person'