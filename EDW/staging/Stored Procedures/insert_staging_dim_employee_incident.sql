

CREATE PROC [staging].[insert_staging_dim_employee_incident]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_employee_incident]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2026-01-19    Pankaj Bhatt		Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_employee_incident]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_employee_incident] (
	 [incident_id] 
	,[incident_title] 
	,[current_stage] 
	,[active_stage_status] 
	,[incident_details] 
	,[incident_business_unit] 
	,[incident_sub_unit] 
	,[incident_team] 
	,[incident_specific_location] 
	,[incident_site_address] 
	,[incident_who_is_involved] 
	,[incident_nature_of_eyewitness] 
	,[actual_likelihood_guidance] 
	,[actual_likelihood_occurrence] 
	,[actual_severity_level] 
	,[actual_severity_consequence] 
	,[ongoing_risk_likelihood_guidance] 
	,[ongoing_risk_expected_outcome] 
	,[ongoing_risk_level] 
	,[ongoing_risk_reoccurrence_likelihood] 
	,[incident_primary_location] 
	,[incident_locations_list] 
	,[is_abuse_procedure_in_place] 
	,[is_assault_procedure_in_place] 
	,[is_fire_risk_cooking_procedure_in_place] 
	,[is_fire_risk_other_procedure_in_place] 
	,[is_smoking_procedure_in_place] 
	,[is_investigation_completed] 
	,[incident_immediate_actions_taken] 
	,[is_incident_in_recordbase] 
	,[incident_recordbase_detail] 
	)
SELECT
	 [incident_id] 
	,[incident_title] 
	,[current_stage] 
	,[active_stage_status] 
	,ISNULL(try_convert(xml,[incident_details],2).value('.', 'NVARCHAR(MAX)'), [incident_details]) AS [incident_details]
	,[incident_business_unit] 
	,[incident_sub_unit] 
	,[incident_team] 
	,[incident_specific_location] 
	,[incident_site_address] 
	,[incident_who_is_involved] 
	,[incident_nature_of_eyewitness] 
	,[actual_likelihood_guidance] 
	,[actual_likelihood_occurrence] 
	,[actual_severity_level] 
	,[actual_severity_consequence] 
	,[ongoing_risk_likelihood_guidance] 
	,[ongoing_risk_expected_outcome] 
	,[ongoing_risk_level] 
	,[ongoing_risk_reoccurrence_likelihood] 
	,[incident_primary_location] 
	,[incident_locations_list] 
	,[is_abuse_procedure_in_place] 
	,[is_assault_procedure_in_place] 
	,[is_fire_risk_cooking_procedure_in_place] 
	,[is_fire_risk_other_procedure_in_place] 
	,[is_smoking_procedure_in_place] 
	,[is_investigation_completed] 
	,ISNULL(try_convert(xml,[incident_immediate_actions_taken],2).value('.', 'NVARCHAR(MAX)'), [incident_immediate_actions_taken]) AS [incident_immediate_actions_taken]
	,[is_incident_in_recordbase] 
	,[incident_recordbase_detail] 
from [Landing].[edw_dim_employee_incident]