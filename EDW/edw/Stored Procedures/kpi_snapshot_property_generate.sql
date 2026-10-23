

CREATE   PROCEDURE [edw].[kpi_snapshot_property_generate]
AS 
/**********************************************************************************************************
 Procedure: [edw].[kpi_snapshot_property_generate]
 Author: Greg Nuthall 
 Created: 2025-12-19
 Purpose: Generates data for [kpi].[ds_snapshot_property_current] by executing all property KPI stored procedures
          and consolidating results into the landing table.

 Notes: This procedure truncates the landing table and repopulates it with current KPI data.
        Each INSERT...EXEC statement calls an individual KPI stored procedure.
        
 REVISIONS:
 Version  Date         Author             Description
 -------  ------------ -----------------  ------------------------------
 1.0      2025-12-19   Greg Nuthall       Initial stored procedure version (only KPI 132)
 2.0      2025-01-15   Greg Nuthall       Added all property KPI stored procedures (40, 62, 63, 64, 131, 152)
                                          Removed KPI 132 (referral KPI, not property)
 2.1       2026-06-26   Greg Nuthall      Replaced kpi_properties_sp_63_tenancy_inspections_last_12_months with
                                          kpi_properties_sp_63_inspections
 **********************************************************************************************************/

BEGIN
    SET NOCOUNT ON;

    -- Remove any existing records
    TRUNCATE TABLE landing.kpi_ds_snapshot_property_current;

    -- KPI 40: TH Properties Are Tenanted
    INSERT INTO landing.kpi_ds_snapshot_property_current (
        [dim_kpi_key],
        [dim_company_key],
        [dim_property_key],
        [dim_service_key],
        [entity_key],
        [kpi_id],
        [property_id],
        [service_id],
        [kpi_value],
        [user_friendly_score_explanation],
        [kpi_status],
        [snapshot_date]
    )
    EXEC edw.kpi_properties_sp_40_TH_properties_are_tenanted;

    -- KPI 62: 95 Percent Properties Actively Tenanted Social Housing
    INSERT INTO landing.kpi_ds_snapshot_property_current (
        [dim_kpi_key],
        [dim_company_key],
        [dim_property_key],
        [dim_service_key],
        [entity_key],
        [kpi_id],
        [property_id],
        [service_id],
        [kpi_value],
        [user_friendly_score_explanation],
        [kpi_status],
        [snapshot_date]
    )
    EXEC edw.kpi_properties_sp_62_95_percent_properties_actively_tenanted_social_housing;

    -- KPI 63: Tenancy Inspections Last 12 Months
    INSERT INTO landing.kpi_ds_snapshot_property_current (
        [dim_kpi_key],
        [dim_company_key],
        [dim_property_key],
        [dim_service_key],
        [entity_key],
        [kpi_id],
        [property_id],
        [service_id],
        [kpi_value],
        [user_friendly_score_explanation],
        [kpi_status],
        [snapshot_date]
    )
    exec edw.kpi_properties_sp_63_inspections
    --EXEC edw.kpi_properties_sp_63_tenancy_inspections_last_12_months;

    -- KPI 64: 3 Monthly Inspection Check Complete
    INSERT INTO landing.kpi_ds_snapshot_property_current (
        [dim_kpi_key],
        [dim_company_key],
        [dim_property_key],
        [dim_service_key],
        [entity_key],
        [kpi_id],
        [property_id],
        [service_id],
        [kpi_value],
        [user_friendly_score_explanation],
        [kpi_status],
        [snapshot_date]
    )
    EXEC edw.kpi_properties_sp_64_3_monthly_inspection_check_complete;

    -- KPI 131: TH Turn Around in 5 Days
    INSERT INTO landing.kpi_ds_snapshot_property_current (
        [dim_kpi_key],
        [dim_company_key],
        [dim_property_key],
        [dim_service_key],
        [entity_key],
        [kpi_id],
        [property_id],
        [service_id],
        [kpi_value],
        [user_friendly_score_explanation],
        [kpi_status],
        [snapshot_date]
    )
    EXEC edw.kpi_property_sp_131_TH_turn_around_in_5_days;

    -- KPI 152: TH MIND Turn Around in 10 Days
    INSERT INTO landing.kpi_ds_snapshot_property_current (
        [dim_kpi_key],
        [dim_company_key],
        [dim_property_key],
        [dim_service_key],
        [entity_key],
        [kpi_id],
        [property_id],
        [service_id],
        [kpi_value],
        [user_friendly_score_explanation],
        [kpi_status],
        [snapshot_date]
    )
    EXEC edw.kpi_properties_sp_152_TH_MIND_turn_around_in_10_days;

    -- Add additional property KPI stored procedures here as they are created
    -- Template for new KPIs:
    /*
    INSERT INTO landing.kpi_ds_snapshot_property_current (
        [dim_kpi_key],
        [dim_company_key],
        [dim_property_key],
        [dim_service_key],
        [entity_key],
        [kpi_id],
        [property_id],
        [service_id],
        [kpi_value],
        [user_friendly_score_explanation],
        [kpi_status],
        [snapshot_date]
    )
    EXEC edw.kpi_property_sp_[NUMBER]_[description];
    */

END