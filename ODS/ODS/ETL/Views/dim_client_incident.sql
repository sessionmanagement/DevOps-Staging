CREATE     view [ETL].[dim_client_incident]

as

/**********************************************************************************************************
 View		[ETL].[dim_client_incident]
 Author		Pankaj Bhatt
 Created	2025-10-31
 Purpose	Used to build the edw.dim_client_incident table 

 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2025-10-31		Pankaj Bhatt	Initial version

**************************************************************************************************************/

SELECT 
	1 AS company_key
	,IncidentID as incident_id
	,IncidentDate as incident_date
	,IncidentTitle as incident_title
	,IncidentDescriptionRaw as incident_description
	,IncidentLocation as incident_location
	,IncidentImmediateActionTakenRaw as incident_immediate_action_taken
	,IncidentPossiblePreventionRaw as incident_possible_prevention
	,IncidentFurtherActionRequiredRaw as incident_further_action_required
	,IncidentInvestigationDetailsRaw as incident_investigation_details
	,IncidentCreatedDate as incident_created_date
	,IncidentOutcomeDetailsRaw as incident_outcome_details
FROM RBEAL.dlFactIncident fi
union all
SELECT 
	5 AS company_key
	,IncidentID as incident_id
	,IncidentDate as incident_date
	,IncidentTitle as incident_title
	,IncidentDescriptionRaw as incident_description
	,IncidentLocation as incident_location
	,IncidentImmediateActionTakenRaw as incident_immediate_action_taken
	,IncidentPossiblePreventionRaw as incident_possible_prevention
	,IncidentFurtherActionRequiredRaw as incident_further_action_required
	,IncidentInvestigationDetailsRaw as incident_investigation_details
	,IncidentCreatedDate as incident_created_date
	,IncidentOutcomeDetailsRaw as incident_outcome_details
FROM RBMNB.dlFactIncident fi