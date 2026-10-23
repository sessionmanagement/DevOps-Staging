

CREATE   PROCEDURE [edw].[kpi_snapshot_referral_generate]
AS 
/**********************************************************************************************************
 Procedure: [edw].[kpi_snapshot_referral_generate]
 Author: Greg Nuthall 
 Created: 2025-12-19
 Purpose: Generates data for [kpi].[ds_snapshot_referral_current] by executing all referral KPI stored procedures
          and consolidating results into the landing table.

 Notes: This procedure truncates the landing table and repopulates it with current KPI data.
        Each INSERT...EXEC statement calls an individual KPI stored procedure.
        
 REVISIONS:
 Version  Date         Author             Description
 -------  ------------ -----------------  ------------------------------
 1.0      2025-12-19   Greg Nuthall       Initial stored procedure version (KPIs 132, 134, 129, 133)
 2.0      2025-01-15   Greg Nuthall       Added missing referral KPI stored procedures (88, 135, 136, 137, 141)
                                           Total: 9 referral KPIs

 **********************************************************************************************************/

BEGIN
    SET NOCOUNT ON;

    -- Remove any existing records
    TRUNCATE TABLE landing.kpi_ds_snapshot_referral_current;

    -- KPI 88: All Whānau Are Seen Face to Face Each Week
    INSERT INTO landing.kpi_ds_snapshot_referral_current (
        [dim_kpi_key],
        [dim_company_key],
        [dim_client_referral_key],
        [dim_service_key],
        [entity_key],
        [kpi_id],
        [client_referral_id],
        [service_id],
        [kpi_value],
        [user_friendly_score_explanation],
        [kpi_status],
        [snapshot_date]
    )
    EXEC edw.kpi_referral_sp_88_all_whanau_are_seen_face_to_face_each_week;

    -- KPI 129: Goal Plan Within 14 Days
    INSERT INTO landing.kpi_ds_snapshot_referral_current (
        [dim_kpi_key],
        [dim_company_key],
        [dim_client_referral_key],
        [dim_service_key],
        [entity_key],
        [kpi_id],
        [client_referral_id],
        [service_id],
        [kpi_value],
        [user_friendly_score_explanation],
        [kpi_status],
        [snapshot_date]
    )
    EXEC edw.kpi_referral_sp_129_goal_plan_within_14_days;

    -- KPI 132: Assessment in 28 Days
    INSERT INTO landing.kpi_ds_snapshot_referral_current (
        [dim_kpi_key],
        [dim_company_key],
        [dim_client_referral_key],
        [dim_service_key],
        [entity_key],
        [kpi_id],
        [client_referral_id],
        [service_id],
        [kpi_value],
        [user_friendly_score_explanation],
        [kpi_status],
        [snapshot_date]
    )
    EXEC edw.kpi_referral_sp_132_assessment_in_28_days;

    -- KPI 133: FTF Activity
    INSERT INTO landing.kpi_ds_snapshot_referral_current (
        [dim_kpi_key],
        [dim_company_key],
        [dim_client_referral_key],
        [dim_service_key],
        [entity_key],
        [kpi_id],
        [client_referral_id],
        [service_id],
        [kpi_value],
        [user_friendly_score_explanation],
        [kpi_status],
        [snapshot_date]
    )
    EXEC edw.kpi_referral_sp_133_ftf_activity;

    -- KPI 134: Goal Plan After 28 Days
    INSERT INTO landing.kpi_ds_snapshot_referral_current (
        [dim_kpi_key],
        [dim_company_key],
        [dim_client_referral_key],
        [dim_service_key],
        [entity_key],
        [kpi_id],
        [client_referral_id],
        [service_id],
        [kpi_value],
        [user_friendly_score_explanation],
        [kpi_status],
        [snapshot_date]
    )
    EXEC edw.kpi_referral_sp_134_goal_plan_after_28_days;

    -- KPI 135: Assessment Outcome Review
    INSERT INTO landing.kpi_ds_snapshot_referral_current (
        [dim_kpi_key],
        [dim_company_key],
        [dim_client_referral_key],
        [dim_service_key],
        [entity_key],
        [kpi_id],
        [client_referral_id],
        [service_id],
        [kpi_value],
        [user_friendly_score_explanation],
        [kpi_status],
        [snapshot_date]
    )
    EXEC edw.kpi_referral_sp_135_assessment_outcome_review;

    -- KPI 136: GP Registration
    INSERT INTO landing.kpi_ds_snapshot_referral_current (
        [dim_kpi_key],
        [dim_company_key],
        [dim_client_referral_key],
        [dim_service_key],
        [entity_key],
        [kpi_id],
        [client_referral_id],
        [service_id],
        [kpi_value],
        [user_friendly_score_explanation],
        [kpi_status],
        [snapshot_date]
    )
    EXEC edw.kpi_referral_sp_136_GP_registration;

    -- KPI 137: All Wahiora Engaged Community Activity
    INSERT INTO landing.kpi_ds_snapshot_referral_current (
        [dim_kpi_key],
        [dim_company_key],
        [dim_client_referral_key],
        [dim_service_key],
        [entity_key],
        [kpi_id],
        [client_referral_id],
        [service_id],
        [kpi_value],
        [user_friendly_score_explanation],
        [kpi_status],
        [snapshot_date]
    )
    EXEC edw.kpi_referral_sp_137_all_Wahiora_engaged_community_activity;

    -- KPI 141: TW Access and Choice Seen Within 5 Working Days
    INSERT INTO landing.kpi_ds_snapshot_referral_current (
        [dim_kpi_key],
        [dim_company_key],
        [dim_client_referral_key],
        [dim_service_key],
        [entity_key],
        [kpi_id],
        [client_referral_id],
        [service_id],
        [kpi_value],
        [user_friendly_score_explanation],
        [kpi_status],
        [snapshot_date]
    )
    EXEC edw.kpi_referral_sp_141_tw_access_and_choice_seen_within_5_working_days;

    -- Add additional referral KPI stored procedures here as they are created
    -- Template for new KPIs:
    /*
    INSERT INTO landing.kpi_ds_snapshot_referral_current (
        [dim_kpi_key],
        [dim_company_key],
        [dim_client_referral_key],
        [dim_service_key],
        [entity_key],
        [kpi_id],
        [client_referral_id],
        [service_id],
        [kpi_value],
        [user_friendly_score_explanation],
        [kpi_status],
        [snapshot_date]
    )
    EXEC edw.kpi_referral_sp_[NUMBER]_[description];
    */

END