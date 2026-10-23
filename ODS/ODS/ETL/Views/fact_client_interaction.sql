CREATE VIEW [ETL].[fact_client_interaction] AS 

/**********************************************************************************************************
 View		[ETL].[fact_client_interaction]
 Author		Malhar
 Created	2026-08-03
 Purpose	Used to build the edw.[fact_client_interaction] table 

 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2026-08-03		Malhar Badheka	Initial version
**************************************************************************************************************/

	

SELECT 

1 AS company_key,
fpi.PersonInteractionId as client_interaction_id,
fpi.PersonID as client_id,
fpi.PersonInteractionTypeId as client_interaction_type_id,
du.UserEmployeeNumber as employee_id,
du.UserEmailAddress as employee_email,
fpi.PersonInteractionOccurred as client_interaction_date,
fpi.PersonInteractionCreatedDate client_interaction_created_date,
fpi.PersonInteractionComments as client_interaction_comments 

from rbeal.dlfactpersoninteraction fpi
LEFT JOIN RBEAL.dlDimUser du on du.UserID  = fpi.PersonInteractionCreatedUserID


UNION ALL 


SELECT

5 AS company_key,
fpi.PersonInteractionId as client_interaction_id,
fpi.PersonID as client_id,
fpi.PersonInteractionTypeId as client_interaction_type_id,
du.UserEmployeeNumber as employee_id,
du.UserEmailAddress as employee_email,
fpi.PersonInteractionOccurred as client_interaction_date,
fpi.PersonInteractionCreatedDate client_interaction_created_date,
fpi.PersonInteractionComments as client_interaction_comments 

from RBMNB.dlfactpersoninteraction fpi
LEFT JOIN RBMNB.dlDimUser du on du.UserID  = fpi.PersonInteractionCreatedUserID