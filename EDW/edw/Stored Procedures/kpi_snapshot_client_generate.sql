Create     procedure [edw].[kpi_snapshot_client_generate]
as 

/**********************************************************************************************************
 Procedure: [edw].[kpi_client_generate_data]
 Author : Greg Nuthall 
 Created: 2025-12-19
 Purpose: generates data for [kpi].[ds_snapshot_client_current]

 REVISIONS:
 Version  Date         Author             Description
 -------  ------------ -----------------  ------------------------------
 1.0      2025-12-19   Greg Nuthall       Initial stored procedure version

 **********************************************************************************************************/

BEGIN
    SET NOCOUNT ON;

    --Remove any existing records
    Truncate table landing.kpi_ds_snapshot_client_current;


    INSERT INTO landing.kpi_ds_snapshot_client_current (
        [dim_kpi_key],
        [dim_company_key],
        [dim_client_key],
        [dim_service_key],
        [entity_key],
        [kpi_id],
        [client_id],
        [service_id],
        [kpi_value],
        [user_friendly_score_explanation],
        [kpi_status],
        [snapshot_date]
     
    )
    exec [edw].[kpi_client_sp_92_goal_plan_status]




end