CREATE PROCEDURE [staging].[insert_staging_dim_kpi]
AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_kpi]
PURPOSE:  
NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-01-24    Manish Singh	Initial version
1.1		 2025-09-05    Greg Nuthall	User Story 11130: Added relevant_bu column
1.2		 2026-08-20    Greg Nuthall	User Story 14335: Added additional_report_name column
****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_kpi]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_kpi] (
	 [kpi_id] 
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
	,[additional_report_name]
	,[relevant_bu]
	)
SELECT
	 [kpi_id] 
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
	,[additional_report_name]
	,replace(replace(replace([relevant_bu],'[',''),'"',''),']','')

from [Landing].[edw_dim_kpi]