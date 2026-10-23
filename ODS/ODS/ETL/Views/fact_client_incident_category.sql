CREATE   view [ETL].[fact_client_incident_category]

as

/**********************************************************************************************************
 View		[ETL].[fact_client_incident_category]
 Author		Pankaj Bhatt
 Created	2025-11-05
 Purpose	Used to build the edw.fact_client_incident_category table 

 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2025-11-05		Pankaj Bhatt	Initial version

**************************************************************************************************************/

SELECT 
	1 AS company_key
    ,IncidentID as incident_id
	,IncidentCategoryTypeID as incident_category_type_id
    ,IncidentCategoryCreatedDate as incident_category_created_date    
FROM RBEAL.dlFactIncidentCategory fic
union all
SELECT 
	5 AS company_key
    ,IncidentID as incident_id
	,IncidentCategoryTypeID as incident_category_type_id
    ,IncidentCategoryCreatedDate as incident_category_created_date
FROM RBMNB.dlFactIncidentCategory fic