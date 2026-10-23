/*
 Pre-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be executed before the build script.	
 Use SQLCMD syntax to include a file in the pre-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the pre-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

-- ============================================================
-- Script:  13559_Drop_KPI_Views.sql
-- Purpose: Remove all edw.kpi_* and edw.kpi_snapshot_* views
--          that have been replaced by stored procedures.
-- Runs:    BEFORE DACPAC deployment
-- ============================================================

DECLARE @views TABLE (vname NVARCHAR(200));
INSERT INTO @views VALUES
    ('kpi_client_92_goal_plan_status'),
    ('kpi_kaimahi_12_leave_balance_200hrs'),
    ('kpi_kaimahi_26_last_leave_taken'),
    ('kpi_properties_40_TH_properties_are_tenanted'),
    ('kpi_properties_62_95_percent_properties_actively_tenanted_social_housing'),
    ('kpi_properties_64_3_monthly_inspection_check_complete'),
    ('kpi_property_131_TH_turn_around_in_5_days'),
    ('kpi_property_152_TH_MIND_turn_around_in_10_days'),
    ('kpi_property_62_property_status_is_occupied'),
    ('kpi_property_63_tenancy_inspections_last_12_months'),
    ('kpi_referral_129_goal_plan_within_14_days'),
    ('kpi_referral_132_assessment_in_28_days'),
    ('kpi_referral_133_ftf_activity'),
    ('kpi_referral_134_Goal_Plan_after_28_days'),
    ('kpi_referral_135_assessment_outcome_review'),
    ('kpi_referral_136_GP_registration'),
    ('kpi_referral_137_all_Wahiora_engaged_community_activity'),
    ('kpi_referral_141_tw_access_and_choice_seen_within_5_working_days'),
    ('kpi_referral_88_all_whanau_are_seen_face_to_face_each_week'),
    ('kpi_service_121_bednights_contract_alignment'),
    ('kpi_service_138_kaimahi_and_whanau_case_loads'),
    ('kpi_service_140_support_hours_as_per_contract'),
    ('kpi_snapshot_client'),
    ('kpi_snapshot_kaimahi'),
    ('kpi_snapshot_property'),
    ('kpi_snapshot_referral'),
    ('kpi_snapshot_service'),
    ('kpi_snapshot_tenancy'),
    ('kpi_tenancy_39_signing_tenancy_agreement'),
    ('kpi_tenancy_39_signing_tenancy_agreement_1'),
    ('kpi_tenancy_67_breaches_followed_up_in_ 14+1_days'),
    ('kpi_tenancy_71_arrears');

DECLARE @vname NVARCHAR(200), @sql NVARCHAR(300);
DECLARE cur CURSOR LOCAL FAST_FORWARD FOR SELECT vname FROM @views;
OPEN cur;
FETCH NEXT FROM cur INTO @vname;
WHILE @@FETCH_STATUS = 0
BEGIN
    IF OBJECT_ID(N'edw.' + @vname, 'V') IS NOT NULL
    BEGIN
        SET @sql = N'DROP VIEW edw.' + QUOTENAME(@vname);
        EXEC sp_executesql @sql;
        PRINT 'Dropped: edw.' + @vname;
    END
    FETCH NEXT FROM cur INTO @vname;
END
CLOSE cur;
DEALLOCATE cur;
