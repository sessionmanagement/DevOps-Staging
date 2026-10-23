
CREATE PROCEDURE [edw].[Updateedwfact_property_hazard] 

/***************************************************************************
NAME:     [edw].[Updateedwfact_property_hazard]
PURPOSE:  Insert data from staging to fact_property_hazard
NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-04-23    Greg Nuthall		Initial version
1.1		 2026-02-18    Greg Nuthall		Removed redundant code columns

****************************************************************************/

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
AS BEGIN

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Variables
    DECLARE @batchID int = @pBatchID;
    DECLARE @SourceSystem nvarchar(120) = 'Zavanti.vw_zav_hazardsregister';
    
    DECLARE @stagedRecords int = 0;
    DECLARE @targetRecords int = 0;
    
    DECLARE @insertedRecords int = 0;
    DECLARE @updatedRecords int = 0;
    DECLARE @deletedRecords int = 0;
    
    DECLARE @systemCurrentDate datetime = GETDATE();

    DECLARE @SystemEffectiveFrom datetime = @systemCurrentDate;
    DECLARE @SystemEffectiveTo datetime = DATEADD(second,-1,@SystemEffectiveFrom);
    DECLARE @SystemDefaultEffectiveFrom datetime = '1 January 1900';
    DECLARE @SystemDefaultEffectiveTo datetime = '31 December 2999 23:59:59';

    -- Do not run if there are no records in source
    SELECT @stagedRecords = COUNT(1) FROM [Staging].[ODSETLfact_property_hazard];
    IF( @stagedRecords = 0 )
    BEGIN
        SELECT @targetRecords = COUNT(1) FROM [edw].[fact_property_hazard];

        -- Select success details
        SELECT
             @pErrorRecords = 0
            ,@pInsertRecords = 0
            ,@pUpdateRecords = 0
            ,@pDeleteRecords = 0
            ,@pCompleted = 1
            ,@pTargetRecords = @targetRecords	

        IF (@pOutputParamsAsDataset = 1)
        BEGIN
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
         [property_hazard_id] uniqueidentifier null
        ,[MergeAction] varchar(10)
    );
    BEGIN TRANSACTION;

    BEGIN TRY
        IF( NOT EXISTS (SELECT TOP(1) 1 FROM [edw].[fact_property_hazard]) )
        BEGIN
            -- There are no records in the target; insert all
            INSERT INTO [edw].[fact_property_hazard]
            (
                 [property_hazard_id] 
                ,[hazardsregister_row_id] 
                ,[dim_property_key]
                ,[property_id] 
                ,[hazard_status_label] 
                ,[hazard_condition_label] 
                ,[hazard_asbestos_status_label] 
                ,[hazard_risklevel_label] 
                ,[hazard_asbestos_removed_label] 
                ,[hazard_location_label] 
                ,[hazard_name] 
                ,[hazard_comments] 
                ,[hazard_date_identified] 
                ,[hazard_date_identified_id] 
                ,[hazard_state_code] 
                ,[hazard_status_code_crm] 
                ,[hazard_is_delete_flag] 
                ,[DWHBatchId] 
                ,[DWHEffectiveFrom] 
                ,[DWHEffectiveTo] 
                ,[DWHDMLOperation] 
                ,[DWHIsCurrent] 
                ,[DWHSourceSystem] 
            )
            SELECT
                 src.[property_hazard_id] 
                ,src.[hazardsregister_row_id] 
                ,src.[dim_property_key]
                ,src.[property_id] 
                ,src.[hazard_status_label] 
                ,src.[hazard_condition_label] 
                ,src.[hazard_asbestos_status_label] 
                ,src.[hazard_risklevel_label] 
                ,src.[hazard_asbestos_removed_label] 
                ,src.[hazard_location_label] 
                ,src.[hazard_name] 
                ,src.[hazard_comments] 
                ,src.[hazard_date_identified] 
                ,src.[hazard_date_identified_id] 
                ,src.[hazard_state_code] 
                ,src.[hazard_status_code_crm] 
                ,src.[hazard_is_delete_flag] 
                ,@BatchID AS [DWHBatchId]
                ,CONVERT(datetime,'1 January 1900') AS [DWHEffectiveFrom]
                ,CONVERT(datetime,'31 December 2999 23:59:59') AS [DWHEffectiveTo]
                ,'I' AS [DWHDMLOperation]
                ,1 AS [DWHIsCurrent]
                ,@SourceSystem AS [DWHSourceSystem]
            FROM [Staging].[ODSETLfact_property_hazard] AS src;
        END ELSE BEGIN
            MERGE INTO [edw].[fact_property_hazard] AS trg
            USING 
            (
                SELECT
                 src.[property_hazard_id] 
                ,src.[hazardsregister_row_id] 
                ,src.[dim_property_key]
                ,src.[property_id] 
                ,src.[hazard_status_label] 
                ,src.[hazard_condition_label] 
                ,src.[hazard_asbestos_status_label] 
                ,src.[hazard_risklevel_label] 
                ,src.[hazard_asbestos_removed_label] 
                ,src.[hazard_location_label] 
                ,src.[hazard_name] 
                ,src.[hazard_comments] 
                ,src.[hazard_date_identified] 
                ,src.[hazard_date_identified_id] 
                ,src.[hazard_state_code] 
                ,src.[hazard_status_code_crm] 
                ,src.[hazard_is_delete_flag] 
                ,@BatchID AS [DWHBatchId]
                ,CONVERT(datetime,'1 January 1900') AS [DWHEffectiveFrom]
                ,CONVERT(datetime,'31 December 2999 23:59:59') AS [DWHEffectiveTo]
                ,'I' AS [DWHDMLOperation]
                ,1 AS [DWHIsCurrent]
                ,@SourceSystem AS [DWHSourceSystem]
                FROM [Staging].[ODSETLfact_property_hazard] AS src
            ) AS src ON (src.[property_hazard_id] = trg.[property_hazard_id] AND trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
            -- Retire existing records
            WHEN MATCHED AND EXISTS 
            ( 
                SELECT src.[hazardsregister_row_id], src.[property_id], src.[hazard_status_label], src.[hazard_condition_label], src.[hazard_asbestos_status_label], src.[hazard_risklevel_label], src.[hazard_asbestos_removed_label], src.[hazard_location_label], src.[hazard_name], src.[hazard_comments], src.[hazard_date_identified], src.[hazard_date_identified_id], src.[hazard_state_code], src.[hazard_status_code_crm], src.[hazard_is_delete_flag], CASE WHEN trg.[DWHDMLOperation] = 'D' THEN 'U' ELSE 'X' END
                EXCEPT
                SELECT trg.[hazardsregister_row_id], trg.[property_id], trg.[hazard_status_label], trg.[hazard_condition_label], trg.[hazard_asbestos_status_label], trg.[hazard_risklevel_label], trg.[hazard_asbestos_removed_label], trg.[hazard_location_label], trg.[hazard_name], trg.[hazard_comments], trg.[hazard_date_identified], trg.[hazard_date_identified_id], trg.[hazard_state_code], trg.[hazard_status_code_crm], trg.[hazard_is_delete_flag], 'X'
            ) THEN  UPDATE SET [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
            -- Soft delete missing records
            WHEN NOT MATCHED BY SOURCE AND trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo AND trg.[DWHDMLOperation] <> 'D' THEN UPDATE SET [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
            -- Insert new records
            WHEN NOT MATCHED BY TARGET THEN 
                INSERT 
                (
                     [property_hazard_id] 
                    ,[hazardsregister_row_id] 
                    ,[dim_property_key]
                    ,[property_id] 
                    ,[hazard_status_label] 
                    ,[hazard_condition_label] 
                    ,[hazard_asbestos_status_label] 
                    ,[hazard_risklevel_label] 
                    ,[hazard_asbestos_removed_label] 
                    ,[hazard_location_label] 
                    ,[hazard_name] 
                    ,[hazard_comments] 
                    ,[hazard_date_identified] 
                    ,[hazard_date_identified_id] 
                    ,[hazard_state_code] 
                    ,[hazard_status_code_crm] 
                    ,[hazard_is_delete_flag] 
                    ,[DWHBatchId] 
                    ,[DWHEffectiveFrom] 
                    ,[DWHEffectiveTo] 
                    ,[DWHDMLOperation] 
                    ,[DWHIsCurrent] 
                    ,[DWHSourceSystem] 
                )
                VALUES
                (
                     src.[property_hazard_id] 
                    ,src.[hazardsregister_row_id] 
                    ,src.[dim_property_key]
                    ,src.[property_id] 
                    ,src.[hazard_status_label] 
                    ,src.[hazard_condition_label] 
                    ,src.[hazard_asbestos_status_label] 
                    ,src.[hazard_risklevel_label] 
                    ,src.[hazard_asbestos_removed_label] 
                    ,src.[hazard_location_label] 
                    ,src.[hazard_name] 
                    ,src.[hazard_comments] 
                    ,src.[hazard_date_identified] 
                    ,src.[hazard_date_identified_id] 
                    ,src.[hazard_state_code] 
                    ,src.[hazard_status_code_crm] 
                    ,src.[hazard_is_delete_flag] 
                    ,src.[DWHBatchId] 
                    ,src.[DWHEffectiveFrom] 
                    ,src.[DWHEffectiveTo] 
                    ,src.[DWHDMLOperation] 
                    ,src.[DWHIsCurrent] 
                    ,src.[DWHSourceSystem] 
                )
            OUTPUT  COALESCE(src.[property_hazard_id],inserted.[property_hazard_id]), $action AS [MergeAction] INTO #SummaryOfChanges;

            -- Insert new versions of previously updated records (Updates and Deletes)
            INSERT INTO [edw].[fact_property_hazard]
            (
                 [property_hazard_id] 
                ,[hazardsregister_row_id] 
                ,[dim_property_key]
                ,[property_id] 
                ,[hazard_status_label] 
                ,[hazard_condition_label] 
                ,[hazard_asbestos_status_label] 
                ,[hazard_risklevel_label] 
                ,[hazard_asbestos_removed_label] 
                ,[hazard_location_label] 
                ,[hazard_name] 
                ,[hazard_comments] 
                ,[hazard_date_identified] 
                ,[hazard_date_identified_id] 
                ,[hazard_state_code] 
                ,[hazard_status_code_crm] 
                ,[hazard_is_delete_flag] 
                ,[DWHBatchId]
                ,[DWHEffectiveFrom]
                ,[DWHEffectiveTo]
                ,[DWHIsCurrent]
                ,[DWHSourceSystem]
                ,[DWHDMLOperation]
            )
            SELECT
                 src.[property_hazard_id] 
                ,src.[hazardsregister_row_id] 
                ,src.[dim_property_key]
                ,src.[property_id] 
                ,src.[hazard_status_label] 
                ,src.[hazard_condition_label] 
                ,src.[hazard_asbestos_status_label] 
                ,src.[hazard_risklevel_label] 
                ,src.[hazard_asbestos_removed_label] 
                ,src.[hazard_location_label] 
                ,src.[hazard_name] 
                ,src.[hazard_comments] 
                ,src.[hazard_date_identified] 
                ,src.[hazard_date_identified_id] 
                ,src.[hazard_state_code] 
                ,src.[hazard_status_code_crm] 
                ,src.[hazard_is_delete_flag] 
                ,@BatchID
                ,@SystemEffectiveFrom
                ,@SystemDefaultEffectiveTo
                ,1
                ,'Zavanti.vw_zav_hazardsregister'
                ,'U'
            FROM #SummaryOfChanges AS base
            INNER JOIN [Staging].[ODSETLfact_property_hazard] AS src ON src.[property_hazard_id] = base.[property_hazard_id]
            WHERE base.[MergeAction] = 'UPDATE'

            UNION ALL 

            SELECT
                 tbl.[property_hazard_id] 
                ,tbl.[hazardsregister_row_id] 
                ,tbl.[dim_property_key]
                ,tbl.[property_id] 
                ,tbl.[hazard_status_label] 
                ,tbl.[hazard_condition_label] 
                ,tbl.[hazard_asbestos_status_label] 
                ,tbl.[hazard_risklevel_label] 
                ,tbl.[hazard_asbestos_removed_label] 
                ,tbl.[hazard_location_label] 
                ,tbl.[hazard_name] 
                ,tbl.[hazard_comments] 
                ,tbl.[hazard_date_identified] 
                ,tbl.[hazard_date_identified_id] 
                ,tbl.[hazard_state_code] 
                ,tbl.[hazard_status_code_crm] 
                ,tbl.[hazard_is_delete_flag] 
                ,@BatchID
                ,@SystemEffectiveFrom
                ,@SystemDefaultEffectiveTo
                ,1
                ,'Zavanti.vw_zav_hazardsregister'
                ,'D'
            FROM #SummaryOfChanges AS base
            INNER JOIN [edw].[fact_property_hazard] AS tbl ON tbl.[property_hazard_id] = base.[property_hazard_id] AND tbl.[DWHEffectiveTo] = @SystemEffectiveTo
            LEFT JOIN [Staging].[ODSETLfact_property_hazard] AS src ON src.[property_hazard_id] = base.[property_hazard_id]
            WHERE base.[MergeAction] = 'UPDATE'
            AND  src.[property_hazard_id] IS NULL;
        END;

        -- Get process counts
        SELECT 
             @targetRecords = COUNT(1) 
            ,@insertedRecords = SUM( CASE WHEN [DWHDMLOperation] = 'I' AND [DWHBatchId] = @BatchID THEN 1 ELSE 0 END)
            ,@updatedRecords = ISNULL(@updatedRecords,0) + SUM( CASE WHEN [DWHDMLOperation] = 'U' AND [DWHBatchId] = @BatchID  THEN 1 ELSE 0 END)
            ,@deletedRecords =  SUM( CASE WHEN [DWHDMLOperation] = 'D' AND [DWHBatchId] = @BatchID  THEN 1 ELSE 0 END)
        FROM [edw].[fact_property_hazard]
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
        SELECT @pErrorRecords	AS ErrorRecords,
                @pInsertRecords AS InsertRecords,
                @pUpdateRecords AS UpdateRecords,
                @pDeleteRecords AS DeleteRecords,
                @pCompleted		AS Completed,
                @targetRecords	AS TargetRecords,
                @pErrorMessage  AS ErrorMessage;
    END;
END;