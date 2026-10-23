CREATE   PROC [staging].[insert_staging_fact_property_hazard]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_property_hazard]
PURPOSE:  Insert data from landing to staging for fact_property_hazard

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-04-23    Greg Nuthall		Initial version
1.1		 2026-02-18    Greg Nuthall		Removed redundant code columns

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_property_hazard]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_property_hazard] (
     [property_hazard_id] 
    ,[hazardsregister_row_id] 
    ,[dim_property_key]
    ,[property_id] 
    ,[hazard_status_label] 
    ,[hazard_condition_label] 
    ,[hazard_asbestos_status_label] 
    ,[hazard_risklevel_label] 
    ,[hazard_asbestos_removed_label] 
    ,[hazard_location_label] 
    ,[hazard_name] 
    ,[hazard_comments] 
    ,[hazard_date_identified] 
    ,[hazard_date_identified_id] 
    ,[hazard_state_code] 
    ,[hazard_status_code_crm] 
    ,[hazard_is_delete_flag] 
    )
SELECT
     l.[property_hazard_id] 
    ,l.[hazardsregister_row_id] 
    ,p.dim_property_key
    ,l.[property_id] 
    ,l.[hazard_status_label] 
    ,l.[hazard_condition_label] 
    ,l.[hazard_asbestos_status_label] 
    ,l.[hazard_risklevel_label] 
    ,l.[hazard_asbestos_removed_label] 
    ,l.[hazard_location_label] 
    ,l.[hazard_name] 
    ,l.[hazard_comments] 
    ,l.[hazard_date_identified] 
    ,l.[hazard_date_identified_id] 
    ,l.[hazard_state_code] 
    ,l.[hazard_status_code_crm] 
    ,l.[hazard_is_delete_flag] 
FROM [Landing].[edw_fact_property_hazard] l
LEFT OUTER JOIN edw.dim_property p ON l.property_id = p.property_id AND p.DWHIsCurrent = 1