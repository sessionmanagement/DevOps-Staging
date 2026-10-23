CREATE VIEW [edw].[vw_dim_kpi] AS 

/**********************************************************************************************************
 View		[edw].[vw_dim_kpi]
 Author		Greg Nuthall
 Created	2025-09-05
 Purpose	Current view of KPI dimension with SCD Type 2 filtering
 Notes: 	Provides current records only for reporting purposes
 =========================================================================================================

REVISIONS:
Version	Date		  Author			    Description
-------	------------  ------------------	--------------------------
1.0		05/09/2025    Greg Nuthall		User Story 11130: Initial creation with relevant_bu column
**********************************************************************************************************/

SELECT [dim_kpi_key]
      ,[kpi_id]
      ,[gap_analysis_notes]
      ,[gap_analysis_status]
      ,[kpi_target_green]
      ,[kpi_g_sign]
      ,[kpi_g_value]
      ,[kpi_ru_g_sign]
      ,[kpi_ru_g_value]
      ,[kpi_target_amber]
      ,[kpi_a_sign]
      ,[kpi_a_value]
      ,[kpi_ru_a_sign]
      ,[kpi_ru_a_value]
      ,[kpi_target_rollup_amber]
      ,[kpi_target_rollup_green]
      ,[related_kpi_outcome_lookup_value]
      ,[related_outcome]
      ,[sfa_rollup_area]
      ,[sfa_rollup_areas_strategic_focus_area]
      ,[sfa_rollup_areas_lookup_value]
      ,[specific_measure]
      ,[status]
      ,[what_is_measured]
      ,[call_to_action]
      ,[sim_title]
      ,[additional_reporting]
      ,[relevant_bu]
      ,[DWHBatchId]
      ,[DWHEffectiveFrom]
      ,[DWHEffectiveTo]
      ,[DWHDMLOperation]
      ,[DWHIsCurrent]
      ,[DWHSourceSystem]
  FROM [edw].[dim_kpi]
  WHERE [DWHIsCurrent] = 1 
    AND [DWHDMLOperation] <> 'D'