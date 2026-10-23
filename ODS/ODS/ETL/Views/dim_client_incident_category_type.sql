
/****** Object:  View [ETL].[dim_client_incident_category_type]    Script Date: 5/11/2025 10:27:34 am ******/
/****** Object:  View [ETL].[dim_client_incident_category_type]    Script Date: 22/10/2025 3:50:39 pm ******/


CREATE       view [ETL].[dim_client_incident_category_type]

as

/**********************************************************************************************************
 View		[ETL].[dim_client_incident_category_type]
 Author		Pankaj Bhatt
 Created	2025-10-22
 Purpose	Used to build the edw.dim_client_incident_category_type table 

 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2025-10-22		Pankaj Bhatt	Initial version

**************************************************************************************************************/

SELECT 
	1 AS company_key
	,ict1.IncidentCategoryTypeID as incident_category_type_id
    ,ict1.IncidentCategoryTypeText as incident_category_type_text
    ,ict1.IncidentCategoryTypeParentId as incident_category_type_parent_Id
	,ict2.IncidentCategoryTypeText as incident_category_type_parent_text
	,ict1.IncidentCategoryTypeIsActive as is_incident_category_type_active
FROM RBEAL.dlDimIncidentCategoryType ict1
left outer join RBEAL.dlDimIncidentCategoryType ict2
on ict1.IncidentCategoryTypeParentId = ict2.IncidentCategoryTypeID
union all
SELECT
	5 AS company_key
	,ict1.IncidentCategoryTypeID as incident_category_type_id
    ,ict1.IncidentCategoryTypeText as incident_category_type_text
    ,ict1.IncidentCategoryTypeParentId as incident_category_type_parent_Id
	,ict2.IncidentCategoryTypeText as incident_category_type_parent_text
	,ict1.IncidentCategoryTypeIsActive as is_incident_category_type_active
FROM RBMNB.dlDimIncidentCategoryType ict1
left outer join RBMNB.dlDimIncidentCategoryType ict2
on ict1.IncidentCategoryTypeParentId = ict2.IncidentCategoryTypeID