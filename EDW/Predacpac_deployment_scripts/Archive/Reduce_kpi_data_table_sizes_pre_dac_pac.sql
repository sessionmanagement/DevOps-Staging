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

-----------------------------------------------------------------------------------------------------------------
--staging.ODSETLdim_kpi
-----------------------------------------------------------------------------------------------------------------

-- gap_analysis_notes
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'staging' AND TABLE_NAME = 'ODSETLdim_kpi' AND COLUMN_NAME = 'gap_analysis_notes'
)
BEGIN
    ALTER TABLE [staging].[ODSETLdim_kpi] ALTER COLUMN gap_analysis_notes NVARCHAR(500);
END

-- gap_analysis_status
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'staging' AND TABLE_NAME = 'ODSETLdim_kpi' AND COLUMN_NAME = 'gap_analysis_status'
)
BEGIN
    ALTER TABLE [staging].[ODSETLdim_kpi] ALTER COLUMN gap_analysis_status NVARCHAR(20);
END

-- kpi_target_green
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'staging' AND TABLE_NAME = 'ODSETLdim_kpi' AND COLUMN_NAME = 'kpi_target_green'
)
BEGIN
    ALTER TABLE [staging].[ODSETLdim_kpi] ALTER COLUMN kpi_target_green NVARCHAR(160);
END

-- kpi_g_sign
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'staging' AND TABLE_NAME = 'ODSETLdim_kpi' AND COLUMN_NAME = 'kpi_g_sign'
)
BEGIN
    ALTER TABLE [staging].[ODSETLdim_kpi] ALTER COLUMN kpi_g_sign NVARCHAR(10);
END

-- kpi_g_value
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'staging' AND TABLE_NAME = 'ODSETLdim_kpi' AND COLUMN_NAME = 'kpi_g_value'
)
BEGIN
    ALTER TABLE [staging].[ODSETLdim_kpi] ALTER COLUMN kpi_g_value NUMERIC(10,4);
END

-- kpi_ru_g_sign
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'staging' AND TABLE_NAME = 'ODSETLdim_kpi' AND COLUMN_NAME = 'kpi_ru_g_sign'
)
BEGIN
    ALTER TABLE [staging].[ODSETLdim_kpi] ALTER COLUMN kpi_ru_g_sign NVARCHAR(10);
END

-- kpi_ru_g_value
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'staging' AND TABLE_NAME = 'ODSETLdim_kpi' AND COLUMN_NAME = 'kpi_ru_g_value'
)
BEGIN
    ALTER TABLE [staging].[ODSETLdim_kpi] ALTER COLUMN kpi_ru_g_value NUMERIC(10,4);
END

-- kpi_target_amber
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'staging' AND TABLE_NAME = 'ODSETLdim_kpi' AND COLUMN_NAME = 'kpi_target_amber'
)
BEGIN
    ALTER TABLE [staging].[ODSETLdim_kpi] ALTER COLUMN kpi_target_amber NVARCHAR(160);
END

-- kpi_a_sign
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'staging' AND TABLE_NAME = 'ODSETLdim_kpi' AND COLUMN_NAME = 'kpi_a_sign'
)
BEGIN
    ALTER TABLE [staging].[ODSETLdim_kpi] ALTER COLUMN kpi_a_sign NVARCHAR(10);
END

-- kpi_a_value
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'staging' AND TABLE_NAME = 'ODSETLdim_kpi' AND COLUMN_NAME = 'kpi_a_value'
)
BEGIN
    ALTER TABLE [staging].[ODSETLdim_kpi] ALTER COLUMN kpi_a_value NUMERIC(10,4);
END

-- kpi_ru_a_sign
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'staging' AND TABLE_NAME = 'ODSETLdim_kpi' AND COLUMN_NAME = 'kpi_ru_a_sign'
)
BEGIN
    ALTER TABLE [staging].[ODSETLdim_kpi] ALTER COLUMN kpi_ru_a_sign NVARCHAR(40);
END

-- kpi_ru_a_value
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'staging' AND TABLE_NAME = 'ODSETLdim_kpi' AND COLUMN_NAME = 'kpi_ru_a_value'
)
BEGIN
    ALTER TABLE [staging].[ODSETLdim_kpi] ALTER COLUMN kpi_ru_a_value NUMERIC(10,4);
END

-- kpi_target_rollup_amber
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'staging' AND TABLE_NAME = 'ODSETLdim_kpi' AND COLUMN_NAME = 'kpi_target_rollup_amber'
)
BEGIN
    ALTER TABLE [staging].[ODSETLdim_kpi] ALTER COLUMN kpi_target_rollup_amber NVARCHAR(120);
END

-- kpi_target_rollup_green
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'staging' AND TABLE_NAME = 'ODSETLdim_kpi' AND COLUMN_NAME = 'kpi_target_rollup_green'
)
BEGIN
    ALTER TABLE [staging].[ODSETLdim_kpi] ALTER COLUMN kpi_target_rollup_green NVARCHAR(120);
END

-- related_kpi_outcome_lookup_value
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'staging' AND TABLE_NAME = 'ODSETLdim_kpi' AND COLUMN_NAME = 'related_kpi_outcome_lookup_value'
)
BEGIN
    ALTER TABLE [staging].[ODSETLdim_kpi] ALTER COLUMN related_kpi_outcome_lookup_value NVARCHAR(160);
END

-- related_outcome
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'staging' AND TABLE_NAME = 'ODSETLdim_kpi' AND COLUMN_NAME = 'related_outcome'
)
BEGIN
    ALTER TABLE [staging].[ODSETLdim_kpi] ALTER COLUMN related_outcome NVARCHAR(500);
END

-- sfa_rollup_area
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'staging' AND TABLE_NAME = 'ODSETLdim_kpi' AND COLUMN_NAME = 'sfa_rollup_area'
)
BEGIN
    ALTER TABLE [staging].[ODSETLdim_kpi] ALTER COLUMN sfa_rollup_area NVARCHAR(160);
END

-- sfa_rollup_areas_strategic_focus_area
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'staging' AND TABLE_NAME = 'ODSETLdim_kpi' AND COLUMN_NAME = 'sfa_rollup_areas_strategic_focus_area'
)
BEGIN
    ALTER TABLE [staging].[ODSETLdim_kpi] ALTER COLUMN sfa_rollup_areas_strategic_focus_area NVARCHAR(10);
END

-- sfa_rollup_areas_lookup_value
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'staging' AND TABLE_NAME = 'ODSETLdim_kpi' AND COLUMN_NAME = 'sfa_rollup_areas_lookup_value'
)
BEGIN
    ALTER TABLE [staging].[ODSETLdim_kpi] ALTER COLUMN sfa_rollup_areas_lookup_value NVARCHAR(40);
END

-- specific_measure
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'staging' AND TABLE_NAME = 'ODSETLdim_kpi' AND COLUMN_NAME = 'specific_measure'
)
BEGIN
    ALTER TABLE [staging].[ODSETLdim_kpi] ALTER COLUMN specific_measure NVARCHAR(160);
END

-- status
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'staging' AND TABLE_NAME = 'ODSETLdim_kpi' AND COLUMN_NAME = 'status'
)
BEGIN
    ALTER TABLE [staging].[ODSETLdim_kpi] ALTER COLUMN status NVARCHAR(40);
END

-- what_is_measured
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'staging' AND TABLE_NAME = 'ODSETLdim_kpi' AND COLUMN_NAME = 'what_is_measured'
)
BEGIN
    ALTER TABLE [staging].[ODSETLdim_kpi] ALTER COLUMN what_is_measured NVARCHAR(200);
END

-- call_to_action
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'staging' AND TABLE_NAME = 'ODSETLdim_kpi' AND COLUMN_NAME = 'call_to_action'
)
BEGIN
    ALTER TABLE [staging].[ODSETLdim_kpi] ALTER COLUMN call_to_action NVARCHAR(200);
END

-- sim_title
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'staging' AND TABLE_NAME = 'ODSETLdim_kpi' AND COLUMN_NAME = 'sim_title'
)
BEGIN
    ALTER TABLE [staging].[ODSETLdim_kpi] ALTER COLUMN sim_title NVARCHAR(120);
END

-- additional_reporting
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'staging' AND TABLE_NAME = 'ODSETLdim_kpi' AND COLUMN_NAME = 'additional_reporting'
)
BEGIN
    ALTER TABLE [staging].[ODSETLdim_kpi] ALTER COLUMN additional_reporting NVARCHAR(500);
END



-----------------------------------------------------------------------------------------------------------------
--edw.dim_kpi
-----------------------------------------------------------------------------------------------------------------


-- gap_analysis_notes
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'edw' AND TABLE_NAME = 'dim_kpi' AND COLUMN_NAME = 'gap_analysis_notes'
)
BEGIN
    ALTER TABLE [edw].[dim_kpi] ALTER COLUMN gap_analysis_notes NVARCHAR(500);
END

-- gap_analysis_status
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'edw' AND TABLE_NAME = 'dim_kpi' AND COLUMN_NAME = 'gap_analysis_status'
)
BEGIN
    ALTER TABLE [edw].[dim_kpi] ALTER COLUMN gap_analysis_status NVARCHAR(20);
END

-- kpi_target_green
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'edw' AND TABLE_NAME = 'dim_kpi' AND COLUMN_NAME = 'kpi_target_green'
)
BEGIN
    ALTER TABLE [edw].[dim_kpi] ALTER COLUMN kpi_target_green NVARCHAR(160);
END

-- kpi_g_sign
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'edw' AND TABLE_NAME = 'dim_kpi' AND COLUMN_NAME = 'kpi_g_sign'
)
BEGIN
    ALTER TABLE [edw].[dim_kpi] ALTER COLUMN kpi_g_sign NVARCHAR(10);
END

-- kpi_g_value
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'edw' AND TABLE_NAME = 'dim_kpi' AND COLUMN_NAME = 'kpi_g_value'
)
BEGIN
    ALTER TABLE [edw].[dim_kpi] ALTER COLUMN kpi_g_value NUMERIC(10,4);
END

-- kpi_ru_g_sign
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'edw' AND TABLE_NAME = 'dim_kpi' AND COLUMN_NAME = 'kpi_ru_g_sign'
)
BEGIN
    ALTER TABLE [edw].[dim_kpi] ALTER COLUMN kpi_ru_g_sign NVARCHAR(10);
END

-- kpi_ru_g_value
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'edw' AND TABLE_NAME = 'dim_kpi' AND COLUMN_NAME = 'kpi_ru_g_value'
)
BEGIN
    ALTER TABLE [edw].[dim_kpi] ALTER COLUMN kpi_ru_g_value NUMERIC(10,4);
END

-- kpi_target_amber
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'edw' AND TABLE_NAME = 'dim_kpi' AND COLUMN_NAME = 'kpi_target_amber'
)
BEGIN
    ALTER TABLE [edw].[dim_kpi] ALTER COLUMN kpi_target_amber NVARCHAR(160);
END

-- kpi_a_sign
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'edw' AND TABLE_NAME = 'dim_kpi' AND COLUMN_NAME = 'kpi_a_sign'
)
BEGIN
    ALTER TABLE [edw].[dim_kpi] ALTER COLUMN kpi_a_sign NVARCHAR(10);
END

-- kpi_a_value
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'edw' AND TABLE_NAME = 'dim_kpi' AND COLUMN_NAME = 'kpi_a_value'
)
BEGIN
    ALTER TABLE [edw].[dim_kpi] ALTER COLUMN kpi_a_value NUMERIC(10,4);
END
-- kpi_ru_a_sign
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'edw' AND TABLE_NAME = 'dim_kpi' AND COLUMN_NAME = 'kpi_ru_a_sign'
)
BEGIN
    ALTER TABLE [edw].[dim_kpi] ALTER COLUMN kpi_ru_a_sign NVARCHAR(40);
END

-- kpi_ru_a_value
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'edw' AND TABLE_NAME = 'dim_kpi' AND COLUMN_NAME = 'kpi_ru_a_value'
)
BEGIN
    ALTER TABLE [edw].[dim_kpi] ALTER COLUMN kpi_ru_a_value NUMERIC(10,4);
END

-- kpi_target_rollup_amber
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'edw' AND TABLE_NAME = 'dim_kpi' AND COLUMN_NAME = 'kpi_target_rollup_amber'
)
BEGIN
    ALTER TABLE [edw].[dim_kpi] ALTER COLUMN kpi_target_rollup_amber NVARCHAR(120);
END

-- kpi_target_rollup_green
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'edw' AND TABLE_NAME = 'dim_kpi' AND COLUMN_NAME = 'kpi_target_rollup_green'
)
BEGIN
    ALTER TABLE [edw].[dim_kpi] ALTER COLUMN kpi_target_rollup_green NVARCHAR(120);
END

-- related_kpi_outcome_lookup_value
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'edw' AND TABLE_NAME = 'dim_kpi' AND COLUMN_NAME = 'related_kpi_outcome_lookup_value'
)
BEGIN
    ALTER TABLE [edw].[dim_kpi] ALTER COLUMN related_kpi_outcome_lookup_value NVARCHAR(160);
END

-- related_outcome
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'edw' AND TABLE_NAME = 'dim_kpi' AND COLUMN_NAME = 'related_outcome'
)
BEGIN
    ALTER TABLE [edw].[dim_kpi] ALTER COLUMN related_outcome NVARCHAR(500);
END

-- sfa_rollup_area
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'edw' AND TABLE_NAME = 'dim_kpi' AND COLUMN_NAME = 'sfa_rollup_area'
)
BEGIN
    ALTER TABLE [edw].[dim_kpi] ALTER COLUMN sfa_rollup_area NVARCHAR(160);
END

-- sfa_rollup_areas_strategic_focus_area
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'edw' AND TABLE_NAME = 'dim_kpi' AND COLUMN_NAME = 'sfa_rollup_areas_strategic_focus_area'
)
BEGIN
    ALTER TABLE [edw].[dim_kpi] ALTER COLUMN sfa_rollup_areas_strategic_focus_area NVARCHAR(10);
END

-- sfa_rollup_areas_lookup_value
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'edw' AND TABLE_NAME = 'dim_kpi' AND COLUMN_NAME = 'sfa_rollup_areas_lookup_value'
)
BEGIN
    ALTER TABLE [edw].[dim_kpi] ALTER COLUMN sfa_rollup_areas_lookup_value NVARCHAR(40);
END

-- specific_measure
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'edw' AND TABLE_NAME = 'dim_kpi' AND COLUMN_NAME = 'specific_measure'
)
BEGIN
    ALTER TABLE [edw].[dim_kpi] ALTER COLUMN specific_measure NVARCHAR(160);
END

-- status
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'edw' AND TABLE_NAME = 'dim_kpi' AND COLUMN_NAME = 'status'
)
BEGIN
    ALTER TABLE [edw].[dim_kpi] ALTER COLUMN status NVARCHAR(40);
END
-- what_is_measured
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'edw' AND TABLE_NAME = 'dim_kpi' AND COLUMN_NAME = 'what_is_measured'
)
BEGIN
    ALTER TABLE [edw].[dim_kpi] ALTER COLUMN what_is_measured NVARCHAR(200);
END

-- call_to_action
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'edw' AND TABLE_NAME = 'dim_kpi' AND COLUMN_NAME = 'call_to_action'
)
BEGIN
    ALTER TABLE [edw].[dim_kpi] ALTER COLUMN call_to_action NVARCHAR(200);
END

-- sim_title
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'edw' AND TABLE_NAME = 'dim_kpi' AND COLUMN_NAME = 'sim_title'
)
BEGIN
    ALTER TABLE [edw].[dim_kpi] ALTER COLUMN sim_title NVARCHAR(120);
END

-- additional_reporting
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'edw' AND TABLE_NAME = 'dim_kpi' AND COLUMN_NAME = 'additional_reporting'
)
BEGIN
    ALTER TABLE [edw].[dim_kpi] ALTER COLUMN additional_reporting NVARCHAR(500);
END


-- gap_analysis_notes
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'landing' AND TABLE_NAME = 'edw_dim_kpi' AND COLUMN_NAME = 'gap_analysis_notes'
)
BEGIN
    ALTER TABLE [landing].[edw_dim_kpi] ALTER COLUMN gap_analysis_notes NVARCHAR(500);
END

-- gap_analysis_status
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'landing' AND TABLE_NAME = 'edw_dim_kpi' AND COLUMN_NAME = 'gap_analysis_status'
)
BEGIN
    ALTER TABLE [landing].[edw_dim_kpi] ALTER COLUMN gap_analysis_status NVARCHAR(20);
END

-- kpi_target_green
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'landing' AND TABLE_NAME = 'edw_dim_kpi' AND COLUMN_NAME = 'kpi_target_green'
)
BEGIN
    ALTER TABLE [landing].[edw_dim_kpi] ALTER COLUMN kpi_target_green NVARCHAR(160);
END

-- kpi_g_sign
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'landing' AND TABLE_NAME = 'edw_dim_kpi' AND COLUMN_NAME = 'kpi_g_sign'
)
BEGIN
    ALTER TABLE [landing].[edw_dim_kpi] ALTER COLUMN kpi_g_sign NVARCHAR(10);
END

-- kpi_g_value
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'landing' AND TABLE_NAME = 'edw_dim_kpi' AND COLUMN_NAME = 'kpi_g_value'
)
BEGIN
    ALTER TABLE [landing].[edw_dim_kpi] ALTER COLUMN kpi_g_value NUMERIC(10,4);
END

-- kpi_ru_g_sign
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'landing' AND TABLE_NAME = 'edw_dim_kpi' AND COLUMN_NAME = 'kpi_ru_g_sign'
)
BEGIN
    ALTER TABLE [landing].[edw_dim_kpi] ALTER COLUMN kpi_ru_g_sign NVARCHAR(10);
END

-- kpi_ru_g_value
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'landing' AND TABLE_NAME = 'edw_dim_kpi' AND COLUMN_NAME = 'kpi_ru_g_value'
)
BEGIN
    ALTER TABLE [landing].[edw_dim_kpi] ALTER COLUMN kpi_ru_g_value NUMERIC(10,4);
END

-- kpi_target_amber
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'landing' AND TABLE_NAME = 'edw_dim_kpi' AND COLUMN_NAME = 'kpi_target_amber'
)
BEGIN
    ALTER TABLE [landing].[edw_dim_kpi] ALTER COLUMN kpi_target_amber NVARCHAR(160);
END

-- kpi_a_sign
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'landing' AND TABLE_NAME = 'edw_dim_kpi' AND COLUMN_NAME = 'kpi_a_sign'
)
BEGIN
    ALTER TABLE [landing].[edw_dim_kpi] ALTER COLUMN kpi_a_sign NVARCHAR(10);
END

-- kpi_a_value
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'landing' AND TABLE_NAME = 'edw_dim_kpi' AND COLUMN_NAME = 'kpi_a_value'
)
BEGIN
    ALTER TABLE [landing].[edw_dim_kpi] ALTER COLUMN kpi_a_value NUMERIC(10,4);
END

-- kpi_ru_a_sign
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'landing' AND TABLE_NAME = 'edw_dim_kpi' AND COLUMN_NAME = 'kpi_ru_a_sign'
)
BEGIN
    ALTER TABLE [landing].[edw_dim_kpi] ALTER COLUMN kpi_ru_a_sign NVARCHAR(40);
END

-- kpi_ru_a_value
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'landing' AND TABLE_NAME = 'edw_dim_kpi' AND COLUMN_NAME = 'kpi_ru_a_value'
)
BEGIN
    ALTER TABLE [landing].[edw_dim_kpi] ALTER COLUMN kpi_ru_a_value NUMERIC(10,4);
END

-- kpi_target_rollup_amber
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'landing' AND TABLE_NAME = 'edw_dim_kpi' AND COLUMN_NAME = 'kpi_target_rollup_amber'
)
BEGIN
    ALTER TABLE [landing].[edw_dim_kpi] ALTER COLUMN kpi_target_rollup_amber NVARCHAR(120);
END

-- kpi_target_rollup_green
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'landing' AND TABLE_NAME = 'edw_dim_kpi' AND COLUMN_NAME = 'kpi_target_rollup_green'
)
BEGIN
    ALTER TABLE [landing].[edw_dim_kpi] ALTER COLUMN kpi_target_rollup_green NVARCHAR(120);
END

-- related_kpi_outcome_lookup_value
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'landing' AND TABLE_NAME = 'edw_dim_kpi' AND COLUMN_NAME = 'related_kpi_outcome_lookup_value'
)
BEGIN
    ALTER TABLE [landing].[edw_dim_kpi] ALTER COLUMN related_kpi_outcome_lookup_value NVARCHAR(160);
END

-- related_outcome
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'landing' AND TABLE_NAME = 'edw_dim_kpi' AND COLUMN_NAME = 'related_outcome'
)
BEGIN
    ALTER TABLE [landing].[edw_dim_kpi] ALTER COLUMN related_outcome NVARCHAR(500);
END

-- sfa_rollup_area
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'landing' AND TABLE_NAME = 'edw_dim_kpi' AND COLUMN_NAME = 'sfa_rollup_area'
)
BEGIN
    ALTER TABLE [landing].[edw_dim_kpi] ALTER COLUMN sfa_rollup_area NVARCHAR(160);
END

-- sfa_rollup_areas_strategic_focus_area
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'landing' AND TABLE_NAME = 'edw_dim_kpi' AND COLUMN_NAME = 'sfa_rollup_areas_strategic_focus_area'
)
BEGIN
    ALTER TABLE [landing].[edw_dim_kpi] ALTER COLUMN sfa_rollup_areas_strategic_focus_area NVARCHAR(10);
END

-- sfa_rollup_areas_lookup_value
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'landing' AND TABLE_NAME = 'edw_dim_kpi' AND COLUMN_NAME = 'sfa_rollup_areas_lookup_value'
)
BEGIN
    ALTER TABLE [landing].[edw_dim_kpi] ALTER COLUMN sfa_rollup_areas_lookup_value NVARCHAR(40);
END

-- specific_measure
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'landing' AND TABLE_NAME = 'edw_dim_kpi' AND COLUMN_NAME = 'specific_measure'
)
BEGIN
    ALTER TABLE [landing].[edw_dim_kpi] ALTER COLUMN specific_measure NVARCHAR(160);
END

-- status
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'landing' AND TABLE_NAME = 'edw_dim_kpi' AND COLUMN_NAME = 'status'
)
BEGIN
    ALTER TABLE [landing].[edw_dim_kpi] ALTER COLUMN status NVARCHAR(40);
END

-- what_is_measured
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'landing' AND TABLE_NAME = 'edw_dim_kpi' AND COLUMN_NAME = 'what_is_measured'
)
BEGIN
    ALTER TABLE [landing].[edw_dim_kpi] ALTER COLUMN what_is_measured NVARCHAR(200);
END

-- call_to_action
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'landing' AND TABLE_NAME = 'edw_dim_kpi' AND COLUMN_NAME = 'call_to_action'
)
BEGIN
    ALTER TABLE [landing].[edw_dim_kpi] ALTER COLUMN call_to_action NVARCHAR(200);
END

-- sim_title
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'landing' AND TABLE_NAME = 'edw_dim_kpi' AND COLUMN_NAME = 'sim_title'
)
BEGIN
    ALTER TABLE [landing].[edw_dim_kpi] ALTER COLUMN sim_title NVARCHAR(120);
END

-- additional_reporting
IF EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'landing' AND TABLE_NAME = 'edw_dim_kpi' AND COLUMN_NAME = 'additional_reporting'
)
BEGIN
    ALTER TABLE [landing].[edw_dim_kpi] ALTER COLUMN additional_reporting NVARCHAR(500);
END
