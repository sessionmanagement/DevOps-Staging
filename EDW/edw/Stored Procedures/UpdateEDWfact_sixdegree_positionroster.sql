CREATE PROCEDURE [EDW].[UpdateEDWfact_sixdegree_positionroster]
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
/**********************************************************************************************************
 Procedure	[EDW].[UpdateEDWfact_sixdegree_positionroster]
 Author		Malhar Badheka
 Created		2026-03-17
 Purpose		SCD Type 2 merge for edw.fact_sixdegree_positionroster from staging.
 Notes: 		Called by ETL batch. Requires @pBatchID.
 =========================================================================================================
 REVISIONS:
 Version	 Date		   Author				Description
-------	 ------------  ---------------		--------------------------
 1.0		 2026-03-17   Malhar Badheka		Initial version
 1.1		 2026-03-18   Malhar Badheka		Prefix change EDW to DWH, variable change to source system & dim_sixdegree_entity_key added
 1.2		 2026-04-17   Malhar Badheka		Rename dim_sixdegree_entity_key to dim_service_key; remove entity_key; add entity_code, entity_parent_code; merge key updated to use entity_code
**********************************************************************************************************/
BEGIN

	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	-- Variables
	DECLARE @batchID INT = @pBatchID;
	DECLARE @SourceSystem NVARCHAR(120) = '[ETL].[fact_sixdegree_positionroster]';

	DECLARE @stagedRecords INT = 0;
	DECLARE @targetRecords INT = 0;

	DECLARE @insertedRecords INT = 0;
	DECLARE @updatedRecords INT = 0;
	DECLARE @deletedRecords INT = 0;

	DECLARE @systemCurrentDate DATETIME = GETDATE();

	DECLARE @SystemEffectiveFrom DATETIME = @systemCurrentDate;
	DECLARE @SystemEffectiveTo DATETIME = DATEADD(SECOND, -1, @SystemEffectiveFrom);
	DECLARE @SystemDefaultEffectiveFrom DATETIME = '1 January 1900';
	DECLARE @SystemDefaultEffectiveTo DATETIME = '31 December 2999 23:59:59';

	-- Do not run if there are no records in source
	SELECT @stagedRecords = COUNT(1) FROM [Staging].[ODSETLfact_sixdegree_positionroster];
	IF (@stagedRecords = 0)
	BEGIN
		SELECT @targetRecords = COUNT(1) FROM [EDW].[fact_sixdegree_positionroster];

		SELECT
			 @pErrorRecords  = 0
			,@pInsertRecords = 0
			,@pUpdateRecords = 0
			,@pDeleteRecords = 0
			,@pCompleted     = 1
			,@pTargetRecords = @targetRecords;

		IF (@pOutputParamsAsDataset = 1)
		BEGIN
			SELECT
				 @pErrorRecords  AS ErrorRecords
				,@pInsertRecords AS InsertRecords
				,@pUpdateRecords AS UpdateRecords
				,@pDeleteRecords AS DeleteRecords
				,@pCompleted     AS Completed
				,@targetRecords  AS TargetRecords
				,@pErrorMessage  AS ErrorMessage;
		END;

		RETURN;
	END;

	IF (OBJECT_ID('tempdb..#SummaryOfChanges') IS NOT NULL) DROP TABLE #SummaryOfChanges;
	CREATE TABLE #SummaryOfChanges
	(
		 [sixd_position_key] INT            NULL
		,[entity_code]       NVARCHAR(100)  NULL
		,[MergeAction]       VARCHAR(10)
	);

	BEGIN TRANSACTION;

	BEGIN TRY
		IF (NOT EXISTS (SELECT TOP(1) 1 FROM [EDW].[fact_sixdegree_positionroster]))
		BEGIN
			-- There are no records in the target; insert all
			INSERT INTO [EDW].[fact_sixdegree_positionroster]
			(
				 [position_description]
				,[sixd_position_key]
				,[dim_service_key]
				,[entity_code]
				,[entity_parent_code]
				,[hours]
				,[fte]
				,[allocated_fte]
				,[fte_pa]
				,[hours_pw]
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHDMLOperation]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
			)
			SELECT
				 src.[position_description]
				,src.[sixd_position_key]
				,src.[dim_service_key]
				,src.[entity_code]
				,src.[entity_parent_code]
				,src.[hours]
				,src.[fte]
				,src.[allocated_fte]
				,src.[fte_pa]
				,src.[hours_pw]
				,@batchID                                       AS [DWHBatchId]
				,CONVERT(DATETIME, '1 January 1900')            AS [DWHEffectiveFrom]
				,CONVERT(DATETIME, '31 December 2999 23:59:59') AS [DWHEffectiveTo]
				,'I'                                            AS [DWHDMLOperation]
				,1                                              AS [DWHIsCurrent]
				,@SourceSystem                                  AS [DWHSourceSystem]
			FROM [Staging].[ODSETLfact_sixdegree_positionroster] AS src;
		END ELSE BEGIN
			MERGE INTO [EDW].[fact_sixdegree_positionroster] AS trg
			USING
			(
				SELECT
					 src.[position_description]
					,src.[sixd_position_key]
					,src.[dim_service_key]
					,src.[entity_code]
					,src.[entity_parent_code]
					,src.[hours]
					,src.[fte]
					,src.[allocated_fte]
					,src.[fte_pa]
					,src.[hours_pw]
					,@batchID                                       AS [DWHBatchId]
					,CONVERT(DATETIME, '1 January 1900')            AS [DWHEffectiveFrom]
					,CONVERT(DATETIME, '31 December 2999 23:59:59') AS [DWHEffectiveTo]
					,'I'                                            AS [DWHDMLOperation]
					,1                                              AS [DWHIsCurrent]
					,@SourceSystem                                  AS [DWHSourceSystem]
				FROM [Staging].[ODSETLfact_sixdegree_positionroster] AS src
			) AS src ON (
				    src.[sixd_position_key] = trg.[sixd_position_key]
				AND src.[entity_code]       = trg.[entity_code]
				AND trg.[DWHEffectiveTo]    = @SystemDefaultEffectiveTo
			)
			-- Retire existing records where data has changed
			WHEN MATCHED AND EXISTS
			(
				SELECT src.[position_description], src.[dim_service_key], src.[entity_code], src.[entity_parent_code], src.[hours], src.[fte], src.[allocated_fte], src.[fte_pa], src.[hours_pw], CASE WHEN trg.[DWHDMLOperation] = 'D' THEN 'U' ELSE 'X' END
				EXCEPT
				SELECT trg.[position_description], trg.[dim_service_key], trg.[entity_code], trg.[entity_parent_code], trg.[hours], trg.[fte], trg.[allocated_fte], trg.[fte_pa], trg.[hours_pw], 'X'
			) THEN UPDATE SET [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Soft delete missing records (exclude sentinel rows)
			WHEN NOT MATCHED BY SOURCE
				AND trg.[DWHEffectiveTo]    = @SystemDefaultEffectiveTo
				AND trg.[DWHDMLOperation]  <> 'D'
			THEN UPDATE SET [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Insert new records
			WHEN NOT MATCHED BY TARGET THEN
				INSERT
				(
					 [position_description]
					,[sixd_position_key]
					,[dim_service_key]
					,[entity_code]
					,[entity_parent_code]
					,[hours]
					,[fte]
					,[allocated_fte]
					,[fte_pa]
					,[hours_pw]
					,[DWHBatchId]
					,[DWHEffectiveFrom]
					,[DWHEffectiveTo]
					,[DWHDMLOperation]
					,[DWHIsCurrent]
					,[DWHSourceSystem]
				)
				VALUES
				(
					 src.[position_description]
					,src.[sixd_position_key]
					,src.[dim_service_key]
					,src.[entity_code]
					,src.[entity_parent_code]
					,src.[hours]
					,src.[fte]
					,src.[allocated_fte]
					,src.[fte_pa]
					,src.[hours_pw]
					,src.[DWHBatchId]
					,src.[DWHEffectiveFrom]
					,src.[DWHEffectiveTo]
					,src.[DWHDMLOperation]
					,src.[DWHIsCurrent]
					,src.[DWHSourceSystem]
				)
			OUTPUT
				COALESCE(src.[sixd_position_key], inserted.[sixd_position_key]),
				COALESCE(src.[entity_code],       inserted.[entity_code]),
				$ACTION AS [MergeAction]
			INTO #SummaryOfChanges;

			-- Insert new versions of previously updated and deleted records
			INSERT INTO [EDW].[fact_sixdegree_positionroster]
			(
				 [position_description]
				,[sixd_position_key]
				,[dim_service_key]
				,[entity_code]
				,[entity_parent_code]
				,[hours]
				,[fte]
				,[allocated_fte]
				,[fte_pa]
				,[hours_pw]
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
			)
			SELECT
				 src.[position_description]
				,src.[sixd_position_key]
				,src.[dim_service_key]
				,src.[entity_code]
				,src.[entity_parent_code]
				,src.[hours]
				,src.[fte]
				,src.[allocated_fte]
				,src.[fte_pa]
				,src.[hours_pw]
				,@batchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,@SourceSystem
				,'U'
			FROM #SummaryOfChanges AS base
			INNER JOIN [Staging].[ODSETLfact_sixdegree_positionroster] AS src
				ON  src.[sixd_position_key] = base.[sixd_position_key]
				AND src.[entity_code]       = base.[entity_code]
			WHERE base.[MergeAction] = 'UPDATE'

			UNION ALL

			SELECT
				 tbl.[position_description]
				,tbl.[sixd_position_key]
				,tbl.[dim_service_key]
				,tbl.[entity_code]
				,tbl.[entity_parent_code]
				,tbl.[hours]
				,tbl.[fte]
				,tbl.[allocated_fte]
				,tbl.[fte_pa]
				,tbl.[hours_pw]
				,@batchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,@SourceSystem
				,'D'
			FROM #SummaryOfChanges AS base
			INNER JOIN [EDW].[fact_sixdegree_positionroster] AS tbl
				ON  tbl.[sixd_position_key] = base.[sixd_position_key]
				AND tbl.[entity_code]       = base.[entity_code]
				AND tbl.[DWHEffectiveTo]    = @SystemEffectiveTo
			LEFT JOIN [Staging].[ODSETLfact_sixdegree_positionroster] AS src
				ON  src.[sixd_position_key] = base.[sixd_position_key]
				AND src.[entity_code]       = base.[entity_code]
			WHERE base.[MergeAction] = 'UPDATE'
			  AND src.[sixd_position_key] IS NULL
			  AND src.[entity_code]       IS NULL;
		END;

		-- Get process counts
		SELECT
			 @targetRecords   = COUNT(1)
			,@insertedRecords = SUM(CASE WHEN [DWHDMLOperation] = 'I' AND [DWHBatchId] = @batchID THEN 1 ELSE 0 END)
			,@updatedRecords  = ISNULL(@updatedRecords, 0) + SUM(CASE WHEN [DWHDMLOperation] = 'U' AND [DWHBatchId] = @batchID THEN 1 ELSE 0 END)
			,@deletedRecords  = SUM(CASE WHEN [DWHDMLOperation] = 'D' AND [DWHBatchId] = @batchID THEN 1 ELSE 0 END)
		FROM [EDW].[fact_sixdegree_positionroster]
		WHERE [DWHEffectiveTo] = @SystemDefaultEffectiveTo;

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;

		SET @pErrorRecords  = @stagedRecords - @insertedRecords - @updatedRecords - @deletedRecords;
		SET @pInsertRecords = @insertedRecords;
		SET @pUpdateRecords = @updatedRecords;
		SET @pDeleteRecords = @deletedRecords;
		SET @pCompleted     = 0;
		SET @pTargetRecords = @targetRecords;
		SET @pErrorMessage  = ERROR_MESSAGE();

		IF (@pOutputParamsAsDataset = 1)
		BEGIN
			SELECT
				 @pErrorRecords  AS ErrorRecords
				,@pInsertRecords AS InsertRecords
				,@pUpdateRecords AS UpdateRecords
				,@pDeleteRecords AS DeleteRecords
				,@pCompleted     AS Completed
				,@targetRecords  AS TargetRecords
				,@pErrorMessage  AS ErrorMessage;
		END;
		THROW;
	END CATCH;

	SET @pErrorRecords  = @stagedRecords - @insertedRecords - @updatedRecords - @deletedRecords;
	SET @pInsertRecords = @insertedRecords;
	SET @pUpdateRecords = @updatedRecords;
	SET @pDeleteRecords = @deletedRecords;
	SET @pCompleted     = 1;
	SET @pTargetRecords = @targetRecords;

	IF (@pOutputParamsAsDataset = 1)
	BEGIN
		SELECT
			 @pErrorRecords  AS ErrorRecords
			,@pInsertRecords AS InsertRecords
			,@pUpdateRecords AS UpdateRecords
			,@pDeleteRecords AS DeleteRecords
			,@pCompleted     AS Completed
			,@targetRecords  AS TargetRecords
			,@pErrorMessage  AS ErrorMessage;
	END;
END;
