
CREATE VIEW  [ETL].[dim_client_interaction_type]

/**********************************************************************************************************
 View		[ETL].[dim_client_interaction_type]
 Author		Malhar
 Created	2026-08-03
 Purpose	Used to build the edw.[dim_client_interaction_type] table 

 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2026-08-03		Malhar Badheka	Initial version
**************************************************************************************************************/

AS

SELECT   DISTINCT

 1 AS company_key
,dpit.[PersonInteractionTypeId] as client_interaction_type_id
,dpit.[PersonInteractionTypeCode] as client_interaction_type_code
,dpit.[PersonInteractionTypeName] as client_interaction_type_name
,dpit2.PersonInteractionTypeCode as client_parent_interaction_type_code
,dpit2.PersonInteractionTypeName as client_parent_interaction_type_name

FROM  rbeal.dldimpersoninteractiontype dpit
LEFT JOIN rbeal.dldimpersoninteractiontype dpit2 on dpit.personinteractiontypeparentid = dpit2.personinteractiontypeid

UNION ALL 

SELECT DISTINCT

 5 AS company_key
,dpit.[PersonInteractionTypeId] as client_interaction_type_id
,dpit.[PersonInteractionTypeCode] as client_interaction_type_code
,dpit.[PersonInteractionTypeName] as client_interaction_type_name
,dpit2.PersonInteractionTypeCode as client_parent_interaction_type_code
,dpit2.PersonInteractionTypeName as client_parent_interaction_type_name

FROM RBMNB.dldimpersoninteractiontype dpit 
LEFT JOIN RBMNB.dldimpersoninteractiontype dpit2 on dpit.personinteractiontypeparentid = dpit2.personinteractiontypeid