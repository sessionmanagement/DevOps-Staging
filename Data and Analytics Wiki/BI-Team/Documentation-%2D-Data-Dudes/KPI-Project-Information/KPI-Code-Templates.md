**kpi_kaimahi**

/****** Object:  View [edw].[kpi_kaimahi_nnn_description]    Script Date: 26/05/2025 7:56:47 am ******/
---SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--CREATE VIEW [edw].[kpi_kaimahi_nnn_description] AS 
/**********************************************************************************************************
 KPI View:  
 Author  :  
 Created :    
 Purpose  :  
 User Story :
  
 Notes: View created on EDW tables
 =========================================================================================================

 REVISIONS:
 Version   Date       Author          Description
-------  ------------  ------------------  --------------------------
 1.0       
 **********/

WITH selected_kpi
     AS (SELECT TOP 1 dim_kpi.kpi_id,
                      dim_kpi.dim_kpi_key,
                      dim_kpi.what_is_measured,
                      dim_kpi.kpi_g_value,
                      dim_kpi.kpi_a_value,
                      dim_kpi.kpi_g_sign,
                      dim_kpi.kpi_a_sign
         FROM   edw.dim_kpi 
         WHERE  dim_kpi.dwhdmloperation <> 'D'
                AND dim_kpi.dwhiscurrent = 1
--- SET KPI ID HERE ----------------
                AND dim_kpi.kpi_id =  99
				--==============================================
                ORDER  BY dim_kpi.dim_kpi_key DESC),
Service_type_grouping
AS (
	SELECT DISTINCT dim_kpi.kpi_id,
		dim_kpi.dim_kpi_key,
		dim_service.service_id
	FROM edw.dim_kpi
	LEFT JOIN edw.bridge_kpi_measure_to_service_type_group
		ON dim_kpi.dim_kpi_key = bridge_kpi_measure_to_service_type_group.dim_kpi_key
	LEFT JOIN edw.dim_kpi_service_type_grouping
		ON bridge_kpi_measure_to_service_type_group.service_type_grouping_id = dim_kpi_service_type_grouping.dim_kpi_service_type_grouping_key
			AND dim_kpi_service_type_grouping.dwhiscurrent = 1
	LEFT JOIN edw.bridge_kpi_service_type_to_grouping
		ON bridge_kpi_measure_to_service_type_group.dim_kpi_service_type_grouping_key = bridge_kpi_service_type_to_grouping.dim_kpi_service_type_grouping_key
	LEFT JOIN edw.dim_kpi_service_type
		ON bridge_kpi_service_type_to_grouping.dim_kpi_service_type_key = dim_kpi_service_type.dim_kpi_service_type_key
	LEFT JOIN edw.dim_service
		ON dim_kpi_service_type.service_type = dim_service.service_type_name
			AND dim_service.dwhiscurrent = 1
			AND dim_service.dwhdmloperation <> 'd'
	WHERE dim_kpi.dwhiscurrent = 1
		--===added this to avoid duplicates
		AND dim_kpi.kpi_id = (
			SELECT kpi_id
			FROM selected_kpi
			)
	),
	/*******************************************************************************************************
      3) [ms_count]: For each KPI, count how many service_id’s are mapped.
         - If service_count=0 => that KPI has no mapped services => keep all
         - If service_count>0 => restrict to that set
      *******************************************************************************************************/
ms_count_0
AS (
	SELECT (
			SELECT DISTINCT kpi_id
			FROM selected_kpi
			) AS kpi_id,
		service_id
	FROM service_type_grouping
	),

ms_count
AS (
	SELECT kpi_id
		,Count(service_id) AS service_count
	FROM ms_count_0
	where kpi_id in (select distinct kpi_id from selected_kpi)
	GROUP BY kpi_id
	),

	--====change table name nn to something more meaningful depending on what you're doing
	--====put nn in here - this is where you want to create your values
		 --================================================================
nn as (select dim_employee_key
			 , dim_service.dim_company_key
			 , dim_service.service_id
			 , dim_service.dim_service_key 
			 , '' as kpi_value  -- calculate your KPI here.
			  
			  ----======choose your fact table here
			  from edw.fact_employee_remuneration 
			  
			  INNER JOIN edw.dim_service on fact_employee_remuneration.dim_service_key = dim_service.dim_service_key
),
     final_table
     AS (SELECT vw_current_employee.dim_company_key,
                vw_current_employee.employee_id,
                vw_current_employee.dim_service_key,
                dim_service.service_id,
                vw_current_employee.dim_employee_key,
                --====== put KPI value Here
                0 as kpi_value ,
                --======= put explanation case statement here
                '' AS user_friendly_score_explanation
         FROM   edw.vw_current_employee 
                INNER JOIN nn
                        ON vw_current_employee.dim_employee_key = nn.dim_employee_key
                           AND vw_current_employee.dim_company_key = nn.dim_company_key
                INNER JOIN edw.dim_service 
                        ON vw_current_employee.dim_service_key = dim_service.dim_service_key
         WHERE  dim_service.dwhdmloperation <> 'D'
      
        )
---======== add stuff here, BUT remove CTE after checking for duplicates
--remove this when duplicates are checked for
, finalforchecking as (

--====================================================

SELECT selected_kpi.dim_kpi_key,
       final_table.dim_company_key,
       final_table.dim_employee_key,
       final_table.employee_id,
       Concat(666, '_', final_table.employee_id, '_', final_table.service_id, '_',
       final_table.dim_company_key) AS
       entity_key,
       final_table.service_id,
       final_table.kpi_value,
       final_table.user_friendly_score_explanation,
       CASE
         WHEN final_table.kpi_value IS NULL THEN 1
         WHEN ( selected_kpi.kpi_g_sign = '>='
                AND final_table.kpi_value >= selected_kpi.kpi_g_value )
               OR ( selected_kpi.kpi_g_sign = '>'
                    AND final_table.kpi_value > selected_kpi.kpi_g_value )
               OR ( selected_kpi.kpi_g_sign = '<='
                    AND final_table.kpi_value <= selected_kpi.kpi_g_value )
               OR ( selected_kpi.kpi_g_sign = '<'
                    AND final_table.kpi_value < selected_kpi.kpi_g_value )
               OR ( selected_kpi.kpi_g_sign = '='
                    AND final_table.kpi_value = selected_kpi.kpi_g_value ) THEN 3
         WHEN ( selected_kpi.kpi_a_sign = '>='
                AND final_table.kpi_value >= selected_kpi.kpi_a_value )
               OR ( selected_kpi.kpi_a_sign = '>'
                    AND final_table.kpi_value > selected_kpi.kpi_a_value )
               OR ( selected_kpi.kpi_a_sign = '<='
                    AND final_table.kpi_value <= selected_kpi.kpi_a_value )
               OR ( selected_kpi.kpi_a_sign = '<'
                    AND final_table.kpi_value < selected_kpi.kpi_a_value )
               OR ( selected_kpi.kpi_a_sign = '='
                    AND final_table.kpi_value = selected_kpi.kpi_a_value ) THEN 2
         ELSE 1
       END
       AS kpi_status
FROM   final_table 
       CROSS JOIN selected_kpi 
		LEFT JOIN service_type_grouping ON service_type_grouping.dim_kpi_key = selected_kpi.dim_kpi_key
		AND service_type_grouping.service_id = final_table.service_id
		LEFT JOIN ms_count ON selected_kpi.kpi_id = ms_count.kpi_id
		WHERE
	/* If KPI  has no mapped services => service_count=0 => keep all. */
	(
		ms_count.service_count IS NULL
		OR ms_count.service_count = 0
		)
		OR
	/* If KPI  does have mapped services => keep only those that appear in kpi_service_map. */
	(service_type_grouping.service_id IS NOT NULL)
	
	
	
	--=====Remove when duplicates are checked
	)

	select entity_key, count(*)
	from finalforchecking
	group by entity_key 

	order by 2 desc 
	
	--============================================
	
	
	;
