CREATE   PROCEDURE [edw].[kpi_snapshot_service_generate]
AS 
/**********************************************************************************************************
 Procedure: [edw].[kpi_snapshot_service_generate]
 Author: Greg Nuthall 
 Created: 2025-01-15
 Purpose: Generates data for [kpi].[ds_snapshot_service_current] by executing all service KPI stored procedures
          and consolidating results into the landing table.

 Notes: This procedure truncates the landing table and repopulates it with current KPI data.
        Each INSERT...EXEC statement calls an individual KPI stored procedure.
        Service KPIs use a different schema - no entity dimension key, only dim_service_key and service_id.
        
 REVISIONS:
 Version  Date         Author             Description
 -------  ------------ -----------------  ------------------------------
 1.0      2025-01-15   Greg Nuthall       Initial stored procedure version with all 3 service KPIs

 **********************************************************************************************************/

BEGIN
    SET NOCOUNT ON;

    -- Remove any existing records
    TRUNCATE TABLE landing.kpi_ds_snapshot_service_current;

    -- KPI 121: Bed Nights Contract Alignment
    INSERT INTO landing.kpi_ds_snapshot_service_current (
        [dim_kpi_key],
        [dim_company_key],
        [dim_service_key],
        [entity_key],
        [kpi_id],
        [service_id],
        [kpi_value],
        [user_friendly_score_explanation],
        [kpi_status],
        [snapshot_date]
    )
    EXEC edw.kpi_service_sp_121_bednights_contract_alignment;

    -- KPI 138: Kaimahi and Whānau Case Loads
    INSERT INTO landing.kpi_ds_snapshot_service_current (
        [dim_kpi_key],
        [dim_company_key],
        [dim_service_key],
        [entity_key],
        [kpi_id],
        [service_id],
        [kpi_value],
        [user_friendly_score_explanation],
        [kpi_status],
        [snapshot_date]
    )
    EXEC edw.kpi_service_sp_138_kaimahi_and_whanau_case_loads;

    -- KPI 140: Support Hours as Per Contract
    INSERT INTO landing.kpi_ds_snapshot_service_current (
        [dim_kpi_key],
        [dim_company_key],
        [dim_service_key],
        [entity_key],
        [kpi_id],
        [service_id],
        [kpi_value],
        [user_friendly_score_explanation],
        [kpi_status],
        [snapshot_date]
    )
    EXEC edw.kpi_service_sp_140_support_hours_as_per_contract;

    -- Add additional service KPI stored procedures here as they are created
    -- Template for new KPIs:
    /*
    INSERT INTO landing.kpi_ds_snapshot_service_current (
        [dim_kpi_key],
        [dim_company_key],
        [dim_service_key],
        [entity_key],
        [kpi_id],
        [service_id],
        [kpi_value],
        [user_friendly_score_explanation],
        [kpi_status],
        [snapshot_date]
    )
    EXEC edw.kpi_service_sp_[NUMBER]_[description];
    */

END