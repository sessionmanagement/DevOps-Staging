/****** Object:  View [ETL].[dim_kpi]    Script Date: 20/08/2026 10:01:12 am ******/
CREATE   VIEW [ETL].[dim_kpi]

as

/**********************************************************************************************************
 View		[ETL].[dim_kpi]
 Author		Manish Singh
 Created	2025/01/24	
 Purpose	Used to build the edw.dim_kpi table 

 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2025/01/24		Manish Singh		Initial version
--2.0		 2025/03/26		Stefen Hasselberg	Building the KPI Diminsion off tables in the ODS
--2.1		 2025/03/31	    Stefen Hasselberg	rename the id column to kpi_id
--3.1        2025/04/09     Manish Singh		Added [sim_title],m.[additional_reporting] columns in view
--3.2		 2025-09-04     Greg Nuthall		Added relevant_bu column
--3.3		 2026-08-20     Greg Nuthall		User Story 14335: Added additional_report_name column
**************************************************************************************************************/

	SELECT
	  m.id as kpi_id
	, m.gap_analysis_notes
	, m.gap_analysis_status
	, m.kpi_target_green
	, m.kpi_g_sign
	, m.kpi_g_value
	, m.kpi_ru_g_sign
	, m.kpi_ru_g_value
	, m.kpi_target_amber
	, m.kpi_a_sign
	, m.kpi_a_value
	, m.kpi_ru_a_sign
	, m.kpi_ru_a_value
	, m.kpi_target_rollup_amber
	, m.kpi_target_rollup_green
	, d.title as related_kpi_outcome_lookup_value
	, d.outcome as related_outcome
	, m.sfa_rollup_area
	, r.roll_up_id as sfa_rollup_areas_strategic_focus_area
	, r.strategic_focus_area as sfa_rollup_areas_lookup_value
	, m.specific_measure
	, m.[status]
	, m.what_is_measured
	, m.call_to_action
	, null as applies_to_service_type_grouping
	,m.[sim_title]
	,m.[additional_reporting]
	,m.additional_report_name
	,m.relevant_bu

	FROM kpi.measure as m
	left join kpi.definitions as d on m.related_kpi_outcome_lookup = d.id
	left join kpi.sfa_rollup_areas as r on m.sfa_rollup_area_lookup_id = r.id