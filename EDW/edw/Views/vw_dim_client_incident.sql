
CREATE VIEW [edw].[vw_dim_client_incident]

/**********************************************************************************************************
 View      [edw].[vw_dim_client_incident] 
 Purpose   Build the edw.vw_dim_client_incident view 

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2026-03-10	   Pankaj Bhatt			Initial creation of stored procedure
1.1     2026-09-10     Greg Nuthall         Removed PII data columns
 **********************************************************************************************************/

AS
SELECT [dim_client_incident_key]
      ,[dim_client_incident_company_key_incident_id_key]
      ,[dim_company_key]
      ,[incident_id]
      ,[incident_date]
      ,[incident_title]
      ,[incident_description]
      ,[incident_location]
      ,[incident_immediate_action_taken]
      ,[incident_possible_prevention]
      ,'' as [incident_further_action_required]
      ,[incident_investigation_details]
      ,[incident_created_date]
      ,[incident_outcome_details]
      ,[DWHBatchId]
      ,[DWHEffectiveFrom]
      ,[DWHEffectiveTo]
      ,[DWHDMLOperation]
      ,[DWHIsCurrent]
      ,[DWHSourceSystem]
  FROM [edw].[dim_client_incident]