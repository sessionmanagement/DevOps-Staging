
CREATE   procedure [edw].[kpi_snapshot_kaimahi_generate]
as 

/**********************************************************************************************************
 Procedure: [edw].[kpi_kaimahi_generate_data]
 Author : Greg Nuthall 
 Created: 2025-12-19
 Purpose: generates data for [kpi].[ds_snapshot_kaimahi_current]

 REVISIONS:
 Version  Date         Author             Description
 -------  ------------ -----------------  ------------------------------
 1.0      2025-12-19   Greg Nuthall       Initial stored procedure version
 1.1      2026-06-26   Greg Nuthall       Added KPI 148

 **********************************************************************************************************/

BEGIN
    SET NOCOUNT ON;


    --Remove any existing records
    Truncate table landing.kpi_ds_snapshot_kaimahi_current;




    INSERT INTO landing.kpi_ds_snapshot_kaimahi_current (
        [dim_kpi_key],
        [dim_company_key],
        [dim_employee_key],
        [dim_service_key],
        [kpi_id],
        [employee_id],
        [service_id],
        [entity_key],
        [kpi_value],
        [user_friendly_score_explanation],
        [kpi_status],
        [snapshot_date]
     
    )
    exec edw.kpi_kaimahi_sp_12_leave_balance_200hrs;


    INSERT INTO landing.kpi_ds_snapshot_kaimahi_current (
        [dim_kpi_key],
        [dim_company_key],
        [dim_employee_key],
        [dim_service_key],
        [kpi_id],
        [employee_id],
        [service_id],
        [entity_key],
        [kpi_value],
        [user_friendly_score_explanation],
        [kpi_status],
        [snapshot_date]
     
    )
    exec edw.kpi_kaimahi_sp_26_last_leave_taken;

    INSERT INTO landing.kpi_ds_snapshot_kaimahi_current (
        [dim_kpi_key],
        [dim_company_key],
        [dim_employee_key],
        [dim_service_key],
        [kpi_id],
        [employee_id],
        [service_id],
        [entity_key],
        [kpi_value],
        [user_friendly_score_explanation],
        [kpi_status],
        [snapshot_date]
     
    )
    exec edw.kpi_kaimahi_sp_148_police_vetting;

end