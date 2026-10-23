
CREATE   PROCEDURE [edw].[kpi_snapshot_tenancy_generate]
AS 
/**********************************************************************************************************
 Procedure: [edw].[kpi_snapshot_tenancy_generate]
 Author: Greg Nuthall 
 Created: 2025-01-15
 Purpose: Generates data for [kpi].[ds_snapshot_tenancy_current] by executing all tenancy KPI stored procedures
          and consolidating results into the landing table.

 Notes: This procedure truncates the landing table and repopulates it with current KPI data.
        Each INSERT...EXEC statement calls an individual KPI stored procedure.
        Tenancy KPIs relate to property tenancies and include dim_property_tenancy_key.
        
 REVISIONS:
 Version  Date         Author             Description
 -------  ------------ -----------------  ------------------------------
 1.0      2025-01-15   Greg Nuthall       Initial stored procedure version with all 3 tenancy KPIs
 1.1      2026-07-01   Greg Nuthall       Changed KPI 67 and added KPI 158 and KPI 159
 1.2      2026-09-21   Greg Nuthall       Added KPI 82  
 **********************************************************************************************************/

BEGIN
    SET NOCOUNT ON;

    -- Remove any existing records
    TRUNCATE TABLE landing.kpi_ds_snapshot_tenancy_current;

    -- KPI 39: Signing Tenancy Agreement
    INSERT INTO landing.kpi_ds_snapshot_tenancy_current (
        [dim_kpi_key],
        [dim_company_key],
        [dim_property_tenancy_key],
        [dim_service_key],
        [entity_key],
        [kpi_id],
        [property_tenancy_id],
        [service_id],
        [kpi_value],
        [user_friendly_score_explanation],
        [kpi_status],
        [snapshot_date]
    )
    EXEC edw.kpi_tenancy_sp_39_signing_tenancy_agreement;

    -- KPI 67: Breaches Followed Up in 14+1 Days
    INSERT INTO landing.kpi_ds_snapshot_tenancy_current (
        [dim_kpi_key],
        [dim_company_key],
        [dim_property_tenancy_key],
        [dim_service_key],
        [entity_key],
        [kpi_id],
        [property_tenancy_id],
        [service_id],
        [kpi_value],
        [user_friendly_score_explanation],
        [kpi_status],
        [snapshot_date]
    )
    exec [edw].[kpi_tenancy_sp_67_breaches]
    --EXEC edw.kpi_tenancy_sp_67_breaches_followed_up_in_14_plus_1_days;

    -- KPI 71: Arrears
    INSERT INTO landing.kpi_ds_snapshot_tenancy_current (
        [dim_kpi_key],
        [dim_company_key],
        [dim_property_tenancy_key],
        [dim_service_key],
        [entity_key],
        [kpi_id],
        [property_tenancy_id],
        [service_id],
        [kpi_value],
        [user_friendly_score_explanation],
        [kpi_status],
        [snapshot_date]
    )
    EXEC edw.kpi_tenancy_sp_71_arrears;


    -- KPI 82: key_information
    INSERT INTO landing.kpi_ds_snapshot_tenancy_current (
        [dim_kpi_key],
        [dim_company_key],
        [dim_property_tenancy_key],
        [dim_service_key],
        [entity_key],
        [kpi_id],
        [property_tenancy_id],
        [service_id],
        [kpi_value],
        [user_friendly_score_explanation],
        [kpi_status],
        [snapshot_date]
    )
    EXEC edw.kpi_tenancy_sp_82_key_information_captured
    
    -- KPI 158: rent payments
    INSERT INTO landing.kpi_ds_snapshot_tenancy_current (
        [dim_kpi_key],
        [dim_company_key],
        [dim_property_tenancy_key],
        [dim_service_key],
        [entity_key],
        [kpi_id],
        [property_tenancy_id],
        [service_id],
        [kpi_value],
        [user_friendly_score_explanation],
        [kpi_status],
        [snapshot_date]
    )
    EXEC 
    [edw].[kpi_tenancy_sp_158_rent_payments]

    -- KPI 159: Renewals
    INSERT INTO landing.kpi_ds_snapshot_tenancy_current (
        [dim_kpi_key],
        [dim_company_key],
        [dim_property_tenancy_key],
        [dim_service_key],
        [entity_key],
        [kpi_id],
        [property_tenancy_id],
        [service_id],
        [kpi_value],
        [user_friendly_score_explanation],
        [kpi_status],
        [snapshot_date]
    )
    EXEC [edw].[kpi_tenancy_sp_159_tenancy_renewals]



    -- Add additional tenancy KPI stored procedures here as they are created
    -- Template for new KPIs:
    /*
    INSERT INTO landing.kpi_ds_snapshot_tenancy_current (
        [dim_kpi_key],
        [dim_company_key],
        [dim_property_tenancy_key],
        [dim_service_key],
        [entity_key],
        [kpi_id],
        [property_tenancy_id],
        [service_id],
        [kpi_value],
        [user_friendly_score_explanation],
        [kpi_status],
        [snapshot_date]
    )
    EXEC edw.kpi_tenancy_sp_[NUMBER]_[description];
    */

END