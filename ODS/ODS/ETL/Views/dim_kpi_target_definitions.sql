create view [ETL].[dim_kpi_target_definitions] AS

/**********************************************************************************************************
 View		[ETL].[dim_kpi_target_definitions]
 Author		Greg Nuthall
 Created	2025/04/11	
 Purpose	Service target definitions table from the Organisational Performance Sharepoint
 site added to the EDW so that analyst can build kpi's with service specific targets. 

 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2025-04-14		Greg Nuthall	Initial version
--1.1		 2025-05-26		Greg Nuthall	Added outcome_tool_review
--1.2		 2025-10-27		Greg Nuthall	Added goal_planning_applies (User Story 11499)
**************************************************************************************************************/

SELECT [id] as target_definition_id
      ,[service_id]
	  ,[service_type_lookup_id] as service_type_id
      ,[region]
      ,[temp_region]
      ,[district]
      ,[bed_nights]
	  ,[case_load] as caseload
      ,[fully_staffed_fte]
      ,[support_hours]
	  ,[programmes_delivered]
	  ,[service_action_plan_link]
	  ,[bed_nights_applied] as bed_nights_applies
	  ,[fully_staffed_applies] as fully_staffed_applies
	  ,[support_hours_applied] as support_hours_applies
	  ,[prog_delievered_target_applies] as prog_delivered_target_applies
	  ,[case_load_targets_appliced] as caseload_target_applies
	  ,[goal_planning_applied] as goal_planning_applies
	  ,[outcome_tool_review]
	      
  FROM [kpi].[target_definitions]
GO


