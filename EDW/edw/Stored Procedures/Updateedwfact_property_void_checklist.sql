
CREATE   PROCEDURE [edw].[Updateedwfact_property_void_checklist]

 /**********************************************************************************************************
 Procedure	[edw].[Updateedwfact_property_void_checklist] 
 Author		Greg Nuthall
 Created	2026-02-27	
 Purpose	Property void checklist - Zavanti.vw_zav_voidchecklist to populate fact_property_void_checklist
			Simplified version with reduced columns (85 → 42 columns, 50.6% reduction)
 Notes: 		
			- This is a fact table with SCD Type 1 logic (updates in place, no versioning)
			- Uses simplified column names (removed "void_checklist_" prefix from most columns)
			- Uses dim_property_category_key (renamed from dim_void_category_key)
			- Work Item: 12210 - Property field improvements
 =========================================================================================================
		
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--2.0		 2026-02-27		Greg Nuthall	Created from original fact_void_checklist procedure with reduced columns
--2.1         2026-07-27    Greg Nuthall	Added void_checklist_state_code + void_checklist_state_code_name
                                            (User Story 14211, Gap D)      
--*********************************************************************************************************/

    @pBatchID int,
    @pIndexRebuildThreshold int,
    @pOutputParamsAsDataset int = 0,
    @pErrorRecords int = null OUTPUT,
    @pInsertRecords int = null OUTPUT,
    @pUpdateRecords int = null OUTPUT,
    @pDeleteRecords int = null OUTPUT,
    @pCompleted int = null OUTPUT,
    @pTargetRecords int = null OUTPUT,
    @pErrorMessage varchar(MAX) = null OUTPUT
AS

BEGIN

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Variables
    DECLARE @batchID int = @pBatchID;
    DECLARE @SourceSystem nvarchar(120) = 'Zavanti.vw_zav_voidchecklist';

    DECLARE @stagedRecords int = 0;
    DECLARE @targetRecords int = 0;

    DECLARE @insertedRecords int = 0;
    DECLARE @updatedRecords int = 0;
    DECLARE @deletedRecords int = 0;

    DECLARE @systemCurrentDate datetime = GETDATE();

    DECLARE @SystemEffectiveFrom datetime = @systemCurrentDate;
    DECLARE @SystemEffectiveTo datetime = DATEADD(SECOND, -1, @SystemEffectiveFrom);
    DECLARE @SystemDefaultEffectiveFrom datetime = '1 January 1900';
    DECLARE @SystemDefaultEffectiveTo datetime = '31 December 2999 23:59:59';

    -- Do not run if there are no records in source
    SELECT @stagedRecords = COUNT(1)
    FROM [staging].[ODSETLfact_property_void_checklist];
    IF( @stagedRecords = 0 )
	BEGIN
        SELECT @targetRecords = COUNT(1)
        FROM [edw].[fact_property_void_checklist];

        -- Select success details
        SELECT
            @pErrorRecords = 0
			, @pInsertRecords = 0
			, @pUpdateRecords = 0
			, @pDeleteRecords = 0
			, @pCompleted = 1
			, @pTargetRecords = @targetRecords;

        IF (@pOutputParamsAsDataset = 1)
		BEGIN
            -- Select return parameters as a dataset
            SELECT @pErrorRecords	AS ErrorRecords,
                @pInsertRecords AS InsertRecords,
                @pUpdateRecords AS UpdateRecords,
                @pDeleteRecords AS DeleteRecords,
                @pCompleted		AS Completed,
                @targetRecords	AS TargetRecords,
                @pErrorMessage  AS ErrorMessage;
        END;

        RETURN;
    END;

    IF( OBJECT_ID( 'tempdb..#SummaryOfChanges') IS NOT NULL ) DROP TABLE #SummaryOfChanges;
    CREATE TABLE #SummaryOfChanges
    (
        [void_checklist_id] UNIQUEIDENTIFIER NULL
		,[offered_property_id] UNIQUEIDENTIFIER NULL
		,[property_id] UNIQUEIDENTIFIER NULL
		,[vacated_tenancy_id] UNIQUEIDENTIFIER NULL
		,[void_category_id] UNIQUEIDENTIFIER NULL
		,[MergeAction] VARCHAR(10)
    );

    BEGIN TRANSACTION;

    BEGIN TRY
		IF( NOT EXISTS (SELECT TOP(1)
        1
    FROM [edw].[fact_property_void_checklist]) )
		BEGIN
        -- Insert default records first (keys 0 and -1)
        SET IDENTITY_INSERT [edw].[fact_property_void_checklist] ON;

        INSERT INTO [edw].[fact_property_void_checklist]
            (
            [fact_property_void_checklist_key]
            ,[dim_property_key]
            ,[dim_property_tenancy_key]
            ,[dim_offered_property_key]
            ,[dim_property_void_category_key]
            ,[void_checklist_id]
            ,[void_checklist_status]
            ,[void_checklist_status_name]
			,[void_checklist_state_code]
			,[void_checklist_state_code_name]
            ,[offered_property_id]
            ,[offered_property_entity_type]
            ,[property_id]
            ,[property_entity_type]
            ,[vacated_tenancy_id]
            ,[vacated_tenancy_entity_type]
            ,[void_category_id]
            ,[void_category_entity_type]
            ,[owner_id]
            ,[owner_entity_type]
            ,[comments]
            ,[created_on]
            ,[owner_id_name]
            ,[assessment_scoping]
            ,[bond_recovery_forms_completed]
            ,[date_key_received_from_tenant]
            ,[date_keys_to_tenancy_team_to_allocate]
            ,[date_pre_vacate_inspection]
            ,[date_tenancy_terminated]
            ,[void_checklist_name]
            ,[offered_property_name]
            ,[property_name]
            ,[property_units_submitted_to_bos_approved]
            ,[target_completion_date_vacant]
            ,[target_completion_date_void]
            ,[tenancy_resolved_and_exited]
            ,[utilities_connections_recorded_and_setup_if_applicable]
            ,[utilities_disconnected]
            ,[vacated_tenancy_name]
            ,[void_category_name]
            ,[property_void_checklist_id]
            ,[void_completed_date]
            ,[is_delete_flag]
            ,[DWHBatchId]
            ,[DWHEffectiveFrom]
            ,[DWHEffectiveTo]
            ,[DWHDMLOperation]
            ,[DWHIsCurrent]
            ,[DWHSourceSystem]
            )
        VALUES
            -- Key 0 (N/A)
            (
                0 -- fact_property_void_checklist_key
				, 0 -- dim_property_key
				, 0 -- dim_property_tenancy_key
				, 0 -- dim_offered_property_key
				, 0 -- dim_property_category_key
				, CAST(0x0 AS UNIQUEIDENTIFIER) -- void_checklist_id
				, 0 -- void_checklist_status
				, 'N/A' -- void_checklist_status_name
				, 0 -- void_checklist_state
				, 'N/A' -- void_checklist_state_name
				, CAST(0x0 AS UNIQUEIDENTIFIER) -- offered_property_id
				, 'N/A' -- offered_property_entity_type
				, CAST(0x0 AS UNIQUEIDENTIFIER) -- property_id
				, 'N/A' -- property_entity_type
				, CAST(0x0 AS UNIQUEIDENTIFIER) -- vacated_tenancy_id
				, 'N/A' -- vacated_tenancy_entity_type
				, CAST(0x0 AS UNIQUEIDENTIFIER) -- void_category_id
				, 'N/A' -- void_category_entity_type
				, CAST(0x0 AS UNIQUEIDENTIFIER) -- owner_id
				, 'N/A' -- owner_entity_type
				, 'N/A' -- comments
				, CONVERT(DATETIME, '1 January 1900') -- created_on
				, 'N/A' -- owner_id_name
				, CONVERT(DATETIME, '1 January 1900') -- assessment_scoping
				, CONVERT(DATETIME, '1 January 1900') -- bond_recovery_forms_completed
				, CONVERT(DATETIME, '1 January 1900') -- date_key_received_from_tenant
				, CONVERT(DATETIME, '1 January 1900') -- date_keys_to_tenancy_team_to_allocate
				, CONVERT(DATETIME, '1 January 1900') -- date_pre_vacate_inspection
				, CONVERT(DATETIME, '1 January 1900') -- date_tenancy_terminated
				, 'N/A' -- void_checklist_name
				, 'N/A' -- offered_property_name
				, 'N/A' -- property_name
				, CONVERT(DATETIME, '1 January 1900') -- property_units_submitted_to_bos_approved
				, CONVERT(DATETIME, '1 January 1900') -- target_completion_date_vacant
				, CONVERT(DATETIME, '1 January 1900') -- target_completion_date_void
				, CONVERT(DATETIME, '1 January 1900') -- tenancy_resolved_and_exited
				, CONVERT(DATETIME, '1 January 1900') -- utilities_connections_recorded_and_setup_if_applicable
				, CONVERT(DATETIME, '1 January 1900') -- utilities_disconnected
				, 'N/A' -- vacated_tenancy_name
				, 'N/A' -- void_category_name
				, CAST(0x0 AS UNIQUEIDENTIFIER) -- property_void_checklist_id
				, CONVERT(DATETIME, '1 January 1900') -- void_completed_date
				, 0 -- is_delete_flag
				, @BatchID -- DWHBatchId
				, CONVERT(DATETIME, '1 January 1900') -- DWHEffectiveFrom
				, CONVERT(DATETIME, '31 December 2999 23:59:59') -- DWHEffectiveTo
				, 'I' -- DWHDMLOperation
				, 1 -- DWHIsCurrent
				, @SourceSystem -- DWHSourceSystem
			),
            -- Key -1 (Unknown)
            (
                -1 -- fact_property_void_checklist_key
				, -1 -- dim_property_key
				, -1 -- dim_property_tenancy_key
				, -1 -- dim_offered_property_key
				, -1 -- dim_property_category_key
				, CAST(0x0 AS UNIQUEIDENTIFIER) -- void_checklist_id
				, -1 -- void_checklist_status
				, 'Unknown' -- void_checklist_status_name
				, -1 -- void_checklist_state
				, 'Unknown' -- void_checklist_state_name
				, CAST(0x0 AS UNIQUEIDENTIFIER) -- offered_property_id
				, 'Unknown' -- offered_property_entity_type
				, CAST(0x0 AS UNIQUEIDENTIFIER) -- property_id
				, 'Unknown' -- property_entity_type
				, CAST(0x0 AS UNIQUEIDENTIFIER) -- vacated_tenancy_id
				, 'Unknown' -- vacated_tenancy_entity_type
				, CAST(0x0 AS UNIQUEIDENTIFIER) -- void_category_id
				, 'Unknown' -- void_category_entity_type
				, CAST(0x0 AS UNIQUEIDENTIFIER) -- owner_id
				, 'Unknown' -- owner_entity_type
				, 'Unknown' -- comments
				, CONVERT(DATETIME, '1 January 1900') -- created_on
				, 'Unknown' -- owner_id_name
				, CONVERT(DATETIME, '1 January 1900') -- assessment_scoping
				, CONVERT(DATETIME, '1 January 1900') -- bond_recovery_forms_completed
				, CONVERT(DATETIME, '1 January 1900') -- date_key_received_from_tenant
				, CONVERT(DATETIME, '1 January 1900') -- date_keys_to_tenancy_team_to_allocate
				, CONVERT(DATETIME, '1 January 1900') -- date_pre_vacate_inspection
				, CONVERT(DATETIME, '1 January 1900') -- date_tenancy_terminated
				, 'Unknown' -- void_checklist_name
				, 'Unknown' -- offered_property_name
				, 'Unknown' -- property_name
				, CONVERT(DATETIME, '1 January 1900') -- property_units_submitted_to_bos_approved
				, CONVERT(DATETIME, '1 January 1900') -- target_completion_date_vacant
				, CONVERT(DATETIME, '1 January 1900') -- target_completion_date_void
				, CONVERT(DATETIME, '1 January 1900') -- tenancy_resolved_and_exited
				, CONVERT(DATETIME, '1 January 1900') -- utilities_connections_recorded_and_setup_if_applicable
				, CONVERT(DATETIME, '1 January 1900') -- utilities_disconnected
				, 'Unknown' -- vacated_tenancy_name
				, 'Unknown' -- void_category_name
				, CAST(0x0 AS UNIQUEIDENTIFIER) -- property_void_checklist_id
				, CONVERT(DATETIME, '1 January 1900') -- void_completed_date
				, 0 -- is_delete_flag
				, @BatchID -- DWHBatchId
				, CONVERT(DATETIME, '1 January 1900') -- DWHEffectiveFrom
				, CONVERT(DATETIME, '31 December 2999 23:59:59') -- DWHEffectiveTo
				, 'I' -- DWHDMLOperation
				, 1 -- DWHIsCurrent
				, @SourceSystem -- DWHSourceSystem
			);

        SET IDENTITY_INSERT [edw].[fact_property_void_checklist] OFF;

        -- Now insert all staged records
        INSERT INTO [edw].[fact_property_void_checklist]
            (
            [dim_property_key]
            ,[dim_property_tenancy_key]
            ,[dim_offered_property_key]
            ,[dim_property_void_category_key]
            ,[void_checklist_id]
            ,[void_checklist_status]
            ,[void_checklist_status_name]
			,[void_checklist_state_code]
			,[void_checklist_state_code_name]
            ,[offered_property_id]
            ,[offered_property_entity_type]
            ,[property_id]
            ,[property_entity_type]
            ,[vacated_tenancy_id]
            ,[vacated_tenancy_entity_type]
            ,[void_category_id]
            ,[void_category_entity_type]
            ,[owner_id]
            ,[owner_entity_type]
            ,[comments]
            ,[created_on]
            ,[owner_id_name]
            ,[assessment_scoping]
            ,[bond_recovery_forms_completed]
            ,[date_key_received_from_tenant]
            ,[date_keys_to_tenancy_team_to_allocate]
            ,[date_pre_vacate_inspection]
            ,[date_tenancy_terminated]
            ,[void_checklist_name]
            ,[offered_property_name]
            ,[property_name]
            ,[property_units_submitted_to_bos_approved]
            ,[target_completion_date_vacant]
            ,[target_completion_date_void]
            ,[tenancy_resolved_and_exited]
            ,[utilities_connections_recorded_and_setup_if_applicable]
            ,[utilities_disconnected]
            ,[vacated_tenancy_name]
            ,[void_category_name]
            ,[property_void_checklist_id]
            ,[void_completed_date]
            ,[is_delete_flag]
            ,[DWHBatchId]
            ,[DWHEffectiveFrom]
            ,[DWHEffectiveTo]
            ,[DWHDMLOperation]
            ,[DWHIsCurrent]
            ,[DWHSourceSystem]
            )
        SELECT
            src.[dim_property_key]
				, src.[dim_property_tenancy_key]
				, src.[dim_offered_property_key]
				, src.[dim_property_void_category_key]
				, src.[void_checklist_id]
				, src.[void_checklist_status]
				, src.[void_checklist_status_name]
				, src.[void_checklist_state_code]
			    , src.[void_checklist_state_code_name]
				, src.[offered_property_id]
				, src.[offered_property_entity_type]
				, src.[property_id]
				, src.[property_entity_type]
				, src.[vacated_tenancy_id]
				, src.[vacated_tenancy_entity_type]
				, src.[void_category_id]
				, src.[void_category_entity_type]
				, src.[owner_id]
				, src.[owner_entity_type]
				, src.[comments]
				, src.[created_on]
				, src.[owner_id_name]
				, src.[assessment_scoping]
				, src.[bond_recovery_forms_completed]
				, src.[date_key_received_from_tenant]
				, src.[date_keys_to_tenancy_team_to_allocate]
				, src.[date_pre_vacate_inspection]
				, src.[date_tenancy_terminated]
				, src.[void_checklist_name]
				, src.[offered_property_name]
				, src.[property_name]
				, src.[property_units_submitted_to_bos_approved]
				, src.[target_completion_date_vacant]
				, src.[target_completion_date_void]
				, src.[tenancy_resolved_and_exited]
				, src.[utilities_connections_recorded_and_setup_if_applicable]
				, src.[utilities_disconnected]
				, src.[vacated_tenancy_name]
				, src.[void_category_name]
				, src.[property_void_checklist_id]
				, src.[void_completed_date]
				, src.[is_delete_flag]
				, @BatchID AS [DWHBatchId]
				, CONVERT(DATETIME, '1 January 1900') AS [DWHEffectiveFrom]
				, CONVERT(DATETIME, '31 December 2999 23:59:59') AS [DWHEffectiveTo]
				, 'I' AS [DWHDMLOperation]
				, 1 AS [DWHIsCurrent]
				, @SourceSystem AS [DWHSourceSystem]
        FROM [staging].[ODSETLfact_property_void_checklist] AS src;
    END 
		ELSE 
		BEGIN
        -- MERGE for subsequent runs
        MERGE INTO [edw].[fact_property_void_checklist] AS trg
			USING 
			(
				SELECT
					src.[dim_property_key]
					, src.[dim_property_tenancy_key]
					, src.[dim_offered_property_key]
					, src.[dim_property_void_category_key]
					, src.[void_checklist_id]
					, src.[void_checklist_status]
					, src.[void_checklist_status_name]
					, src.[void_checklist_state_code]
					, src.[void_checklist_state_code_name]
					, src.[offered_property_id]
					, src.[offered_property_entity_type]
					, src.[property_id]
					, src.[property_entity_type]
					, src.[vacated_tenancy_id]
					, src.[vacated_tenancy_entity_type]
					, src.[void_category_id]
					, src.[void_category_entity_type]
					, src.[owner_id]
					, src.[owner_entity_type]
					, src.[comments]
					, src.[created_on]
					, src.[owner_id_name]
					, src.[assessment_scoping]
					, src.[bond_recovery_forms_completed]
					, src.[date_key_received_from_tenant]
					, src.[date_keys_to_tenancy_team_to_allocate]
					, src.[date_pre_vacate_inspection]
					, src.[date_tenancy_terminated]
					, src.[void_checklist_name]
					, src.[offered_property_name]
					, src.[property_name]
					, src.[property_units_submitted_to_bos_approved]
					, src.[target_completion_date_vacant]
					, src.[target_completion_date_void]
					, src.[tenancy_resolved_and_exited]
					, src.[utilities_connections_recorded_and_setup_if_applicable]
					, src.[utilities_disconnected]
					, src.[vacated_tenancy_name]
					, src.[void_category_name]
					, src.[property_void_checklist_id]
					, src.[void_completed_date]
					, src.[is_delete_flag]
					, @BatchID AS [DWHBatchId]
					, CONVERT(DATETIME, '1 January 1900') AS [DWHEffectiveFrom]
					, CONVERT(DATETIME, '31 December 2999 23:59:59') AS [DWHEffectiveTo]
					, 'I' AS [DWHDMLOperation]
					, 1 AS [DWHIsCurrent]
					, @SourceSystem AS [DWHSourceSystem]
        FROM [staging].[ODSETLfact_property_void_checklist] AS src
			) AS src 
			ON (
			src.[void_checklist_id] = trg.[void_checklist_id]
            AND ISNULL(src.[offered_property_id], CAST(0x0 AS UNIQUEIDENTIFIER)) = ISNULL(trg.[offered_property_id], CAST(0x0 AS UNIQUEIDENTIFIER))
            AND ISNULL(src.[property_id], CAST(0x0 AS UNIQUEIDENTIFIER)) = ISNULL(trg.[property_id], CAST(0x0 AS UNIQUEIDENTIFIER))
            AND ISNULL(src.[vacated_tenancy_id], CAST(0x0 AS UNIQUEIDENTIFIER)) = ISNULL(trg.[vacated_tenancy_id], CAST(0x0 AS UNIQUEIDENTIFIER))
            AND ISNULL(src.[void_category_id], CAST(0x0 AS UNIQUEIDENTIFIER)) = ISNULL(trg.[void_category_id], CAST(0x0 AS UNIQUEIDENTIFIER))
            AND trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo
			)

			-- Retire existing records when data has changed
			WHEN MATCHED AND EXISTS 
			( 	
				 SELECT
					src.[void_checklist_status]
					, ISNULL(src.[void_checklist_status_name], 'XXXX') AS void_checklist_status_name
					, src.[void_checklist_state_code]
					, ISNULL(src.[void_checklist_state_code_name], 'XXXX') AS void_checklist_state_code_name

					, ISNULL(src.[offered_property_entity_type], 'XXXX') AS offered_property_entity_type
					, ISNULL(src.[property_entity_type], 'XXXX') AS property_entity_type
					, src.[vacated_tenancy_entity_type]
					, ISNULL(src.[void_category_entity_type], 'XXXX') AS void_category_entity_type
					, src.[owner_id]
					, src.[owner_entity_type]
					, ISNULL(src.[comments], 'XXXX') AS comments
					, src.[created_on]
					, src.[owner_id_name]
					, ISNULL(src.[assessment_scoping], '1900-01-01') AS assessment_scoping
					, ISNULL(src.[bond_recovery_forms_completed], '1900-01-01') AS bond_recovery_forms_completed
					, ISNULL(src.[date_key_received_from_tenant], '1900-01-01') AS date_key_received_from_tenant
					, ISNULL(src.[date_keys_to_tenancy_team_to_allocate], '1900-01-01') AS date_keys_to_tenancy_team_to_allocate
					, ISNULL(src.[date_pre_vacate_inspection], '1900-01-01') AS date_pre_vacate_inspection
					, ISNULL(src.[date_tenancy_terminated], '1900-01-01') AS date_tenancy_terminated
					, src.[void_checklist_name]
					, ISNULL(src.[offered_property_name], 'XXXX') AS offered_property_name
					, ISNULL(src.[property_name], 'XXXX') AS property_name
					, ISNULL(src.[property_units_submitted_to_bos_approved], '1900-01-01') AS property_units_submitted_to_bos_approved
					, ISNULL(src.[target_completion_date_vacant], '1900-01-01') AS target_completion_date_vacant
					, ISNULL(src.[target_completion_date_void], '1900-01-01') AS target_completion_date_void
					, ISNULL(src.[tenancy_resolved_and_exited], '1900-01-01') AS tenancy_resolved_and_exited
					, ISNULL(src.[utilities_connections_recorded_and_setup_if_applicable], '1900-01-01') AS utilities_connections_recorded_and_setup_if_applicable
					, ISNULL(src.[utilities_disconnected], '1900-01-01') AS utilities_disconnected
					, ISNULL(src.[vacated_tenancy_name], 'XXXX') AS vacated_tenancy_name
					, src.[void_category_name]
					, src.[property_void_checklist_id]
					, ISNULL(src.[void_completed_date], '1900-01-01') AS void_completed_date
					, src.[is_delete_flag]
					, CASE WHEN trg.[DWHDMLOperation] = 'D' THEN 'U' ELSE 'X' END

        EXCEPT

            SELECT
                trg.[void_checklist_status]
					, ISNULL(trg.[void_checklist_status_name], 'XXXX') AS void_checklist_status_name
					, trg.[void_checklist_state_code]
					, ISNULL(trg.[void_checklist_state_code_name], 'XXXX') AS void_checklist_state_code_name
					, ISNULL(trg.[offered_property_entity_type], 'XXXX') AS offered_property_entity_type
					, ISNULL(trg.[property_entity_type], 'XXXX') AS property_entity_type
					, trg.[vacated_tenancy_entity_type]
					, ISNULL(trg.[void_category_entity_type], 'XXXX') AS void_category_entity_type
					, trg.[owner_id]
					, trg.[owner_entity_type]
					, ISNULL(trg.[comments], 'XXXX') AS comments
					, trg.[created_on]
					, trg.[owner_id_name]
					, ISNULL(trg.[assessment_scoping], '1900-01-01') AS assessment_scoping
					, ISNULL(trg.[bond_recovery_forms_completed], '1900-01-01') AS bond_recovery_forms_completed
					, ISNULL(trg.[date_key_received_from_tenant], '1900-01-01') AS date_key_received_from_tenant
					, ISNULL(trg.[date_keys_to_tenancy_team_to_allocate], '1900-01-01') AS date_keys_to_tenancy_team_to_allocate
					, ISNULL(trg.[date_pre_vacate_inspection], '1900-01-01') AS date_pre_vacate_inspection
					, ISNULL(trg.[date_tenancy_terminated], '1900-01-01') AS date_tenancy_terminated
					, trg.[void_checklist_name]
					, ISNULL(trg.[offered_property_name], 'XXXX') AS offered_property_name
					, ISNULL(trg.[property_name], 'XXXX') AS property_name
					, ISNULL(trg.[property_units_submitted_to_bos_approved], '1900-01-01') AS property_units_submitted_to_bos_approved
					, ISNULL(trg.[target_completion_date_vacant], '1900-01-01') AS target_completion_date_vacant
					, ISNULL(trg.[target_completion_date_void], '1900-01-01') AS target_completion_date_void
					, ISNULL(trg.[tenancy_resolved_and_exited], '1900-01-01') AS tenancy_resolved_and_exited
					, ISNULL(trg.[utilities_connections_recorded_and_setup_if_applicable], '1900-01-01') AS utilities_connections_recorded_and_setup_if_applicable
					, ISNULL(trg.[utilities_disconnected], '1900-01-01') AS utilities_disconnected
					, ISNULL(trg.[vacated_tenancy_name], 'XXXX') AS vacated_tenancy_name
					, trg.[void_category_name]
					, trg.[property_void_checklist_id]
					, ISNULL(trg.[void_completed_date], '1900-01-01') AS void_completed_date
					, trg.[is_delete_flag]
					, 'X'
			
			) THEN UPDATE SET [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Soft delete missing records
			WHEN NOT MATCHED BY SOURCE AND trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo AND trg.[DWHDMLOperation] <> 'D' 
				THEN UPDATE SET [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Insert new records
			WHEN NOT MATCHED BY TARGET THEN 
				INSERT 
				(
					 [dim_property_key]
					,[dim_property_tenancy_key]
					,[dim_offered_property_key]
					,[dim_property_void_category_key]
					,[void_checklist_id]
					,[void_checklist_status]
					,[void_checklist_status_name]
					,[void_checklist_state_code]
					,[void_checklist_state_code_name]
					,[offered_property_id]
					,[offered_property_entity_type]
					,[property_id]
					,[property_entity_type]
					,[vacated_tenancy_id]
					,[vacated_tenancy_entity_type]
					,[void_category_id]
					,[void_category_entity_type]
					,[owner_id]
					,[owner_entity_type]
					,[comments]
					,[created_on]
					,[owner_id_name]
					,[assessment_scoping]
					,[bond_recovery_forms_completed]
					,[date_key_received_from_tenant]
					,[date_keys_to_tenancy_team_to_allocate]
					,[date_pre_vacate_inspection]
					,[date_tenancy_terminated]
					,[void_checklist_name]
					,[offered_property_name]
					,[property_name]
					,[property_units_submitted_to_bos_approved]
					,[target_completion_date_vacant]
					,[target_completion_date_void]
					,[tenancy_resolved_and_exited]
					,[utilities_connections_recorded_and_setup_if_applicable]
					,[utilities_disconnected]
					,[vacated_tenancy_name]
					,[void_category_name]
					,[property_void_checklist_id]
					,[void_completed_date]
					,[is_delete_flag]
					,[DWHBatchId]
					,[DWHEffectiveFrom]
					,[DWHEffectiveTo]
					,[DWHDMLOperation]
					,[DWHIsCurrent]
					,[DWHSourceSystem]
				)
				VALUES
				(
					 src.[dim_property_key]
					,src.[dim_property_tenancy_key]
					,src.[dim_offered_property_key]
					,src.[dim_property_void_category_key]
					,src.[void_checklist_id]
					,src.[void_checklist_status]
					,src.[void_checklist_status_name]
					,src.[void_checklist_state_code]
					,src.[void_checklist_state_code_name]
					,src.[offered_property_id]
					,src.[offered_property_entity_type]
					,src.[property_id]
					,src.[property_entity_type]
					,src.[vacated_tenancy_id]
					,src.[vacated_tenancy_entity_type]
					,src.[void_category_id]
					,src.[void_category_entity_type]
					,src.[owner_id]
					,src.[owner_entity_type]
					,src.[comments]
					,src.[created_on]
					,src.[owner_id_name]
					,src.[assessment_scoping]
					,src.[bond_recovery_forms_completed]
					,src.[date_key_received_from_tenant]
					,src.[date_keys_to_tenancy_team_to_allocate]
					,src.[date_pre_vacate_inspection]
					,src.[date_tenancy_terminated]
					,src.[void_checklist_name]
					,src.[offered_property_name]
					,src.[property_name]
					,src.[property_units_submitted_to_bos_approved]
					,src.[target_completion_date_vacant]
					,src.[target_completion_date_void]
					,src.[tenancy_resolved_and_exited]
					,src.[utilities_connections_recorded_and_setup_if_applicable]
					,src.[utilities_disconnected]
					,src.[vacated_tenancy_name]
					,src.[void_category_name]
					,src.[property_void_checklist_id]
					,src.[void_completed_date]
					,src.[is_delete_flag]
					,src.[DWHBatchId]
					,src.[DWHEffectiveFrom]
					,src.[DWHEffectiveTo]
					,src.[DWHDMLOperation]
					,src.[DWHIsCurrent]
					,src.[DWHSourceSystem]
				)
			OUTPUT  
				COALESCE(src.[void_checklist_id], inserted.[void_checklist_id]), 
				COALESCE(src.[offered_property_id], inserted.[offered_property_id]), 
				COALESCE(src.[property_id], inserted.[property_id]), 
				COALESCE(src.[vacated_tenancy_id], inserted.[vacated_tenancy_id]), 
				COALESCE(src.[void_category_id], inserted.[void_category_id]), 
				$action AS [MergeAction] 
			INTO #SummaryOfChanges;

        -- Insert new versions of previously updated records (Updates and Deletes)
        INSERT INTO [edw].[fact_property_void_checklist]
            (
            [dim_property_key]
            ,[dim_property_tenancy_key]
            ,[dim_offered_property_key]
            ,[dim_property_void_category_key]
            ,[void_checklist_id]
            ,[void_checklist_status]
            ,[void_checklist_status_name]
			,[void_checklist_state_code]
			,[void_checklist_state_code_name]
            ,[offered_property_id]
            ,[offered_property_entity_type]
            ,[property_id]
            ,[property_entity_type]
            ,[vacated_tenancy_id]
            ,[vacated_tenancy_entity_type]
            ,[void_category_id]
            ,[void_category_entity_type]
            ,[owner_id]
            ,[owner_entity_type]
            ,[comments]
            ,[created_on]
            ,[owner_id_name]
            ,[assessment_scoping]
            ,[bond_recovery_forms_completed]
            ,[date_key_received_from_tenant]
            ,[date_keys_to_tenancy_team_to_allocate]
            ,[date_pre_vacate_inspection]
            ,[date_tenancy_terminated]
            ,[void_checklist_name]
            ,[offered_property_name]
            ,[property_name]
            ,[property_units_submitted_to_bos_approved]
            ,[target_completion_date_vacant]
            ,[target_completion_date_void]
            ,[tenancy_resolved_and_exited]
            ,[utilities_connections_recorded_and_setup_if_applicable]
            ,[utilities_disconnected]
            ,[vacated_tenancy_name]
            ,[void_category_name]
            ,[property_void_checklist_id]
            ,[void_completed_date]
            ,[is_delete_flag]
            ,[DWHBatchId]
            ,[DWHEffectiveFrom]
            ,[DWHEffectiveTo]
            ,[DWHIsCurrent]
            ,[DWHSourceSystem]
            ,[DWHDMLOperation]
            )
                    SELECT
                src.[dim_property_key]
				, src.[dim_property_tenancy_key]
				, src.[dim_offered_property_key]
				, src.[dim_property_void_category_key]
				, src.[void_checklist_id]
				, src.[void_checklist_status]
				, src.[void_checklist_status_name]
				, src.[void_checklist_state_code]
				, src.[void_checklist_state_code_name]
				, src.[offered_property_id]
				, src.[offered_property_entity_type]
				, src.[property_id]
				, src.[property_entity_type]
				, src.[vacated_tenancy_id]
				, src.[vacated_tenancy_entity_type]
				, src.[void_category_id]
				, src.[void_category_entity_type]
				, src.[owner_id]
				, src.[owner_entity_type]
				, src.[comments]
				, src.[created_on]
				, src.[owner_id_name]
				, src.[assessment_scoping]
				, src.[bond_recovery_forms_completed]
				, src.[date_key_received_from_tenant]
				, src.[date_keys_to_tenancy_team_to_allocate]
				, src.[date_pre_vacate_inspection]
				, src.[date_tenancy_terminated]
				, src.[void_checklist_name]
				, src.[offered_property_name]
				, src.[property_name]
				, src.[property_units_submitted_to_bos_approved]
				, src.[target_completion_date_vacant]
				, src.[target_completion_date_void]
				, src.[tenancy_resolved_and_exited]
				, src.[utilities_connections_recorded_and_setup_if_applicable]
				, src.[utilities_disconnected]
				, src.[vacated_tenancy_name]
				, src.[void_category_name]
				, src.[property_void_checklist_id]
				, src.[void_completed_date]
				, src.[is_delete_flag]
				, @BatchID
				, @SystemEffectiveFrom
				, @SystemDefaultEffectiveTo
				, 1
				, 'Zavanti.vw_zav_voidchecklist'
				, 'U'
            FROM #SummaryOfChanges AS base
                INNER JOIN [staging].[ODSETLfact_property_void_checklist] AS src
                ON src.[void_checklist_id] = base.[void_checklist_id]
                    AND ISNULL(src.[offered_property_id], CAST(0x0 AS UNIQUEIDENTIFIER)) = ISNULL(base.[offered_property_id], CAST(0x0 AS UNIQUEIDENTIFIER))
                    AND ISNULL(src.[property_id], CAST(0x0 AS UNIQUEIDENTIFIER)) = ISNULL(base.[property_id], CAST(0x0 AS UNIQUEIDENTIFIER))
                    AND ISNULL(src.[vacated_tenancy_id], CAST(0x0 AS UNIQUEIDENTIFIER)) = ISNULL(base.[vacated_tenancy_id], CAST(0x0 AS UNIQUEIDENTIFIER))
                    AND ISNULL(src.[void_category_id], CAST(0x0 AS UNIQUEIDENTIFIER)) = ISNULL(base.[void_category_id], CAST(0x0 AS UNIQUEIDENTIFIER))
            WHERE base.[MergeAction] = 'UPDATE'

        UNION ALL

            SELECT
                tbl.[dim_property_key]
				, tbl.[dim_property_tenancy_key]
				, tbl.[dim_offered_property_key]
				, tbl.[dim_property_void_category_key]
				, tbl.[void_checklist_id]
				, tbl.[void_checklist_status]
				, tbl.[void_checklist_status_name]
				, tbl.[void_checklist_state_code]
				, tbl.[void_checklist_state_code_name]
				, tbl.[offered_property_id]
				, tbl.[offered_property_entity_type]
				, tbl.[property_id]
				, tbl.[property_entity_type]
				, tbl.[vacated_tenancy_id]
				, tbl.[vacated_tenancy_entity_type]
				, tbl.[void_category_id]
				, tbl.[void_category_entity_type]
				, tbl.[owner_id]
				, tbl.[owner_entity_type]
				, tbl.[comments]
				, tbl.[created_on]
				, tbl.[owner_id_name]
				, tbl.[assessment_scoping]
				, tbl.[bond_recovery_forms_completed]
				, tbl.[date_key_received_from_tenant]
				, tbl.[date_keys_to_tenancy_team_to_allocate]
				, tbl.[date_pre_vacate_inspection]
				, tbl.[date_tenancy_terminated]
				, tbl.[void_checklist_name]
				, tbl.[offered_property_name]
				, tbl.[property_name]
				, tbl.[property_units_submitted_to_bos_approved]
				, tbl.[target_completion_date_vacant]
				, tbl.[target_completion_date_void]
				, tbl.[tenancy_resolved_and_exited]
				, tbl.[utilities_connections_recorded_and_setup_if_applicable]
				, tbl.[utilities_disconnected]
				, tbl.[vacated_tenancy_name]
				, tbl.[void_category_name]
				, tbl.[property_void_checklist_id]
				, tbl.[void_completed_date]
				, tbl.[is_delete_flag]
				, @BatchID
				, @SystemEffectiveFrom
				, @SystemDefaultEffectiveTo
				, 1
				, 'Zavanti.vw_zav_voidchecklist'
				, 'D'
            FROM #SummaryOfChanges AS base
                INNER JOIN [edw].[fact_property_void_checklist] AS tbl
                ON tbl.[void_checklist_id] = base.[void_checklist_id]
                    AND ISNULL(tbl.[offered_property_id], CAST(0x0 AS UNIQUEIDENTIFIER)) = ISNULL(base.[offered_property_id], CAST(0x0 AS UNIQUEIDENTIFIER))
                    AND ISNULL(tbl.[property_id], CAST(0x0 AS UNIQUEIDENTIFIER)) = ISNULL(base.[property_id], CAST(0x0 AS UNIQUEIDENTIFIER))
                    AND ISNULL(tbl.[vacated_tenancy_id], CAST(0x0 AS UNIQUEIDENTIFIER)) = ISNULL(base.[vacated_tenancy_id], CAST(0x0 AS UNIQUEIDENTIFIER))
                    AND ISNULL(tbl.[void_category_id], CAST(0x0 AS UNIQUEIDENTIFIER)) = ISNULL(base.[void_category_id], CAST(0x0 AS UNIQUEIDENTIFIER))
                    AND tbl.[DWHEffectiveTo] = @SystemEffectiveTo
                LEFT JOIN [staging].[ODSETLfact_property_void_checklist] AS src
                ON src.[void_checklist_id] = base.[void_checklist_id]
                    AND ISNULL(src.[offered_property_id], CAST(0x0 AS UNIQUEIDENTIFIER)) = ISNULL(base.[offered_property_id], CAST(0x0 AS UNIQUEIDENTIFIER))
                    AND ISNULL(src.[property_id], CAST(0x0 AS UNIQUEIDENTIFIER)) = ISNULL(base.[property_id], CAST(0x0 AS UNIQUEIDENTIFIER))
                    AND ISNULL(src.[vacated_tenancy_id], CAST(0x0 AS UNIQUEIDENTIFIER)) = ISNULL(base.[vacated_tenancy_id], CAST(0x0 AS UNIQUEIDENTIFIER))
                    AND ISNULL(src.[void_category_id], CAST(0x0 AS UNIQUEIDENTIFIER)) = ISNULL(base.[void_category_id], CAST(0x0 AS UNIQUEIDENTIFIER))
            WHERE base.[MergeAction] = 'UPDATE'
                AND src.[void_checklist_id] IS NULL
                AND src.[offered_property_id] IS NULL
                AND src.[property_id] IS NULL
                AND src.[vacated_tenancy_id] IS NULL
                AND src.[void_category_id] IS NULL;
    END;

		-- Get process counts
		SELECT
        @targetRecords = COUNT(1) 
			, @insertedRecords = SUM(CASE WHEN [DWHDMLOperation] = 'I' AND [DWHBatchId] = @BatchID THEN 1 ELSE 0 END)
			, @updatedRecords = ISNULL(@updatedRecords, 0) + SUM(CASE WHEN [DWHDMLOperation] = 'U' AND [DWHBatchId] = @BatchID THEN 1 ELSE 0 END)
			, @deletedRecords = SUM(CASE WHEN [DWHDMLOperation] = 'D' AND [DWHBatchId] = @BatchID THEN 1 ELSE 0 END)
    FROM [edw].[fact_property_void_checklist]
    WHERE [DWHEffectiveTo] = @SystemDefaultEffectiveTo;

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;

		SET @pErrorRecords = @stagedRecords - @insertedRecords - @updatedRecords - @deletedRecords;
		SET @pInsertRecords = @insertedRecords;
		SET @pUpdateRecords = @updatedRecords;
		SET @pDeleteRecords = @deletedRecords;
		SET @pCompleted = 0;
		SET @pTargetRecords = @targetRecords;
		SET @pErrorMessage = ERROR_MESSAGE();

		IF (@pOutputParamsAsDataset = 1)
		BEGIN
        -- Select return parameters as a dataset
        SELECT @pErrorRecords	AS ErrorRecords,
            @pInsertRecords AS InsertRecords,
            @pUpdateRecords AS UpdateRecords,
            @pDeleteRecords AS DeleteRecords,
            @pCompleted		AS Completed,
            @targetRecords	AS TargetRecords,
            @pErrorMessage  AS ErrorMessage;
    END;
		THROW;
	END CATCH

    SET @pErrorRecords = @stagedRecords - @insertedRecords - @updatedRecords - @deletedRecords;
    SET @pInsertRecords = @insertedRecords;
    SET @pUpdateRecords = @updatedRecords;
    SET @pDeleteRecords = @deletedRecords;
    SET @pCompleted = 1;
    SET @pTargetRecords = @targetRecords;

    IF (@pOutputParamsAsDataset = 1)
	BEGIN
        -- Select return parameters as a dataset
        SELECT @pErrorRecords	AS ErrorRecords,
            @pInsertRecords AS InsertRecords,
            @pUpdateRecords AS UpdateRecords,
            @pDeleteRecords AS DeleteRecords,
            @pCompleted		AS Completed,
            @targetRecords	AS TargetRecords,
            @pErrorMessage  AS ErrorMessage;
    END;
END;