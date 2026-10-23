CREATE   VIEW [edw].[kpi_tenancy_39_signing_tenancy_agreement] AS 

/**********************************************************************************************************
 KPI View:      [edw].[kpi_tenancy_39_signing_tenancy_agreement]
 Author  :      Mike Ryan
 Modified by:   Timi Boddington
 Created:       22-05-2025
 Purpose  : 
     Evaluates the status of tenancy agreements for properties, supporting KPI ID 39.
     For each property, determines if a valid lease agreement or agreement to extend tenancy is in place,
     and assigns a KPI status (Green/Amber/Red) based on thresholds defined in [edw].[dim_kpi].
 User Story :10179 and 8773
 Notes: View created on EDW tables
 =========================================================================================================
 REVISIONS:
 Version   Date       Author          Description
-------  ------------  ------------------  --------------------------
 1.0     22-05-2025    Mike Ryan           Initial version
 1.1     02-07-2025    Timi Boddington     Didn't have the extra KPI filter tables in it.  Adding in
 1.2     13-08-2025    Timi Boddington     Changing it to Tenancy Focused not Property.  
                                           Removed Motels 
 **********************************************************************************************************/

 --CREATE VIEW [edw].[kpi_tenancy_39_signing_tenancy_agreement] AS 

WITH selected_kpi AS (
    SELECT TOP 1
        dim_kpi.kpi_id,
        dim_kpi.dim_kpi_key,
        dim_kpi.what_is_measured,
        dim_kpi.kpi_g_value,
        dim_kpi.kpi_a_value,
        dim_kpi.kpi_g_sign,
        dim_kpi.kpi_a_sign
    FROM edw.dim_kpi
    WHERE dim_kpi.DWHDMLOperation <> 'D'
      AND dim_kpi.DWHIsCurrent = 1
      AND dim_kpi.kpi_id = 39
    ORDER BY dim_kpi.dim_kpi_key DESC
),
service_type_grouping AS (
    SELECT DISTINCT
        dim_kpi.kpi_id,
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
      AND dim_kpi.kpi_id = (SELECT kpi_id FROM selected_kpi)
),
ms_count_0 AS (
    SELECT
        (SELECT DISTINCT kpi_id FROM selected_kpi) AS kpi_id,
        service_id
    FROM service_type_grouping
),
ms_count AS (
    SELECT
        kpi_id,
        COUNT(service_id) AS service_count
    FROM ms_count_0
    GROUP BY kpi_id
),
dim_current_tenancies AS (
    SELECT
        vw_dim_service.dim_company_key,
        vw_dim_property_tenancy.property_tenancy_id,
        vw_dim_property_tenancy.dim_property_tenancy_key,
        COALESCE(vw_dim_service.dim_service_key, dim_service_2.dim_service_key) AS dim_service_key,
        vw_dim_property.dim_property_key,
        vw_dim_property.property_id,
        vw_dim_property.property_sub_program,
        COALESCE(vw_dim_service.service_name, dim_service_2.service_name) AS service_name,
        COALESCE(vw_dim_service.service_id, dim_service_2.service_id) AS service_id,
        CASE WHEN vw_dim_property.property_current_tenancy IS NULL THEN 0 ELSE 1 END AS currently_tenanted_flag
    FROM edw.vw_dim_property_tenancy
    INNER JOIN edw.vw_dim_property
        ON vw_dim_property_tenancy.property_id = vw_dim_property.property_id
        AND vw_dim_property.DWHIsCurrent = 1
        AND vw_dim_property.DWHDMLOperation <> 'D'
    LEFT JOIN edw.vw_dim_service
        ON vw_dim_property.property_contract_bc_service_code = vw_dim_service.service_code
        AND vw_dim_service.DWHIsCurrent = 1
        AND vw_dim_service.DWHDMLOperation <> 'D'
    LEFT JOIN edw.vw_dim_service AS dim_service_2
        ON vw_dim_property.property_bc_service_code = dim_service_2.service_code
        AND dim_service_2.DWHIsCurrent = 1
        AND dim_service_2.DWHDMLOperation <> 'D'
    WHERE vw_dim_property_tenancy.DWHIsCurrent = 1
      AND vw_dim_property_tenancy.DWHDMLOperation <> 'D'
      AND vw_dim_property.property_statecode = 'Active'
      AND vw_dim_property_tenancy.property_tenant_opportunity_status IN ('new','active arrears','active')
      AND vw_dim_property.property_name NOT LIKE '%parent%'
      AND ISNULL(vw_dim_property.property_confirmed_disposal_date, '2099-12-31') >= GETDATE()
      AND ISNULL(vw_dim_property.property_acquired_date, '2099-12-31') <= GETDATE()
),
dim_current_tenancies_2 AS (
    SELECT
        vw_dim_service.dim_company_key,
        dim_current_tenancies.dim_service_key,
        dim_current_tenancies.dim_property_key,
        dim_current_tenancies.property_id,
        dim_current_tenancies.property_tenancy_id,
        dim_current_tenancies.dim_property_tenancy_key,
        dim_current_tenancies.service_id,
        dim_current_tenancies.currently_tenanted_flag,
        dim_current_tenancies.property_sub_program,
        dim_kpi_service_type_grouping.service_type_grouping
    FROM dim_current_tenancies
    LEFT JOIN edw.vw_dim_service
        ON dim_current_tenancies.dim_service_key = vw_dim_service.dim_service_key
        AND vw_dim_service.dwhdmloperation <> 'D'
        AND vw_dim_service.dwhiscurrent = 1
    LEFT JOIN edw.dim_kpi_service_type
        ON vw_dim_service.service_type_name = dim_kpi_service_type.service_type
        AND dim_kpi_service_type.DWHIsCurrent = 1
    LEFT JOIN edw.bridge_kpi_service_type_to_grouping
        ON dim_kpi_service_type.dim_kpi_service_type_key = bridge_kpi_service_type_to_grouping.dim_kpi_service_type_key
    --AND bridge_kpi_service_type_to_grouping.DWHIsCurrent = 1
    LEFT JOIN edw.dim_kpi_service_type_grouping
        ON bridge_kpi_service_type_to_grouping.service_type_grouping_id = dim_kpi_service_type_grouping.service_type_grouping_id
        AND dim_kpi_service_type_grouping.DWHIsCurrent = 1
    WHERE dim_current_tenancies.dim_service_key IS NOT NULL
),
final_table AS (
    SELECT
        CONCAT(
            '888', '_', dim_current_tenancies_2.property_tenancy_id, '_',
            dim_current_tenancies_2.service_id, '_', dim_current_tenancies_2.dim_company_key
        ) AS entity_key, --====I'm hoping dim_company_key = company_id ;-)
        dim_current_tenancies_2.dim_company_key,
        dim_current_tenancies_2.property_id,
        dim_current_tenancies_2.property_tenancy_id,
        dim_current_tenancies_2.dim_property_key,
        dim_current_tenancies_2.dim_property_tenancy_key,
        CASE
            WHEN [vw_dim_property_tenancy].[property_tenancy_lease_agreement_flag] = 1
              OR [vw_dim_property_tenancy].[property_tenancy_agreement_to_extend_tenancy_received_flag] = 1
                THEN 1
            ELSE 0
        END AS kpi_value,
        CASE
            WHEN [vw_dim_property_tenancy].[property_tenancy_lease_agreement_flag] = 1
                THEN 'Housing agreement OK'
            WHEN [vw_dim_property_tenancy].[property_tenancy_agreement_to_extend_tenancy_received_flag] = 1
                THEN 'Agreement to extend received'
            ELSE 'No agreement in place'
        END AS user_friendly_score_explanation,
        dim_current_tenancies_2.dim_service_key,
        dim_current_tenancies_2.service_id
    FROM dim_current_tenancies_2
    INNER JOIN edw.vw_dim_property dp
        ON dp.dim_property_key = dim_current_tenancies_2.dim_property_key
    INNER JOIN edw.vw_dim_property_tenancy
        ON dp.property_id = [vw_dim_property_tenancy].property_id
    WHERE [vw_dim_property_tenancy].DWHDMLOperation <> 'D'
      AND [vw_dim_property_tenancy].DWHIsCurrent = 1
      AND [vw_dim_property_tenancy].property_tenancy_vacate_confirmation_flag = 0
      AND [vw_dim_property_tenancy].property_tenancy_actual_close_date IS NULL
      AND dim_current_tenancies_2.property_sub_program <> 'Motels'
)
SELECT
    selected_kpi.dim_kpi_key,
    final_table.dim_company_key,
    --    final_table.dim_property_key,
    final_table.dim_property_tenancy_key,
    final_table.property_tenancy_id,
    final_table.entity_key,
    final_table.dim_service_key,
    final_table.service_id,
    final_table.kpi_value,
    final_table.user_friendly_score_explanation,
    CASE
        WHEN final_table.kpi_value IS NULL THEN 1
        WHEN (
            selected_kpi.kpi_g_sign = '>=' AND final_table.kpi_value >= selected_kpi.kpi_g_value
        ) OR (
            selected_kpi.kpi_g_sign = '>' AND final_table.kpi_value > selected_kpi.kpi_g_value
        ) OR (
            selected_kpi.kpi_g_sign = '<=' AND final_table.kpi_value <= selected_kpi.kpi_g_value
        ) OR (
            selected_kpi.kpi_g_sign = '<' AND final_table.kpi_value < selected_kpi.kpi_g_value
        ) OR (
            selected_kpi.kpi_g_sign = '=' AND final_table.kpi_value = selected_kpi.kpi_g_value
        ) THEN 3
        WHEN (
            selected_kpi.kpi_a_sign = '>=' AND final_table.kpi_value >= selected_kpi.kpi_a_value
        ) OR (
            selected_kpi.kpi_a_sign = '>' AND final_table.kpi_value > selected_kpi.kpi_a_value
        ) OR (
            selected_kpi.kpi_a_sign = '<=' AND final_table.kpi_value <= selected_kpi.kpi_a_value
        ) OR (
            selected_kpi.kpi_a_sign = '<' AND final_table.kpi_value < selected_kpi.kpi_a_value
        ) OR (
            selected_kpi.kpi_a_sign = '=' AND final_table.kpi_value = selected_kpi.kpi_a_value
        ) THEN 2
        ELSE 1
    END AS kpi_status
FROM final_table
CROSS JOIN selected_kpi
LEFT JOIN service_type_grouping
    ON service_type_grouping.dim_kpi_key = selected_kpi.dim_kpi_key
    AND service_type_grouping.service_id = final_table.service_id
LEFT JOIN ms_count
    ON selected_kpi.kpi_id = ms_count.kpi_id
WHERE
    (
        ms_count.service_count IS NULL
        OR ms_count.service_count = 0
    )
    OR
    (service_type_grouping.service_id IS NOT NULL)
;