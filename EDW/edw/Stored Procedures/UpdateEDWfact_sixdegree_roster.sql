CREATE PROCEDURE [EDW].[UpdateEDWfact_sixdegree_roster]
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
 Procedure	[EDW].[UpdateEDWfact_sixdegree_roster]
 Author		Malhar Badheka
 Created		2026-03-17
 Purpose		SCD Type 2 merge for edw.fact_sixdegree_roster from staging.
 Notes: 		Called by ETL batch. Requires @pBatchID.
 =========================================================================================================
 REVISIONS:
 Version	 Date		   Author				Description
-------	 ------------  ---------------		--------------------------
 1.0		 2026-03-17   Malhar Badheka		Initial version
 1.1		 2026-03-18   Malhar Badheka		Prefix change EDW to DWH, variable change to source system & dim_sixdegree_entity_key added
 1.2		 2026-04-17   Malhar Badheka		Rename dim_sixdegree_entity_key to dim_service_key; remove entity_key; add entity_code, entity_parent_code; merge key updated to entity_code + roster_shifts
**********************************************************************************************************/
BEGIN

	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	-- Variables
	DECLARE @batchID INT = @pBatchID;
	DECLARE @SourceSystem NVARCHAR(120) = '[ETL].[fact_sixdegree_roster]';

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
	SELECT @stagedRecords = COUNT(1) FROM [Staging].[ODSETLfact_sixdegree_roster];
	IF (@stagedRecords = 0)
	BEGIN
		SELECT @targetRecords = COUNT(1) FROM [EDW].[fact_sixdegree_roster];

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
		 [entity_code]   NVARCHAR(100)  NULL
		,[roster_shifts] NVARCHAR(128)  NULL
		,[MergeAction]   VARCHAR(10)
	);

	BEGIN TRANSACTION;

	BEGIN TRY
		IF (NOT EXISTS (SELECT TOP(1) 1 FROM [EDW].[fact_sixdegree_roster]))
		BEGIN
			-- There are no records in the target; insert all
			INSERT INTO [EDW].[fact_sixdegree_roster]
			(
				 [dim_service_key]
				,[entity_code]
				,[entity_parent_code]
				,[roster_shifts]
				,[monday]
				,[tuesday]
				,[wednesday]
				,[thursday]
				,[friday]
				,[saturday]
				,[sunday]
				,[total shift/week]
				,[roster - fte/week]
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHDMLOperation]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
			)
			SELECT
				 src.[dim_service_key]
				,src.[entity_code]
				,src.[entity_parent_code]
				,src.[roster_shifts]
				,src.[monday]
				,src.[tuesday]
				,src.[wednesday]
				,src.[thursday]
				,src.[friday]
				,src.[saturday]
				,src.[sunday]
				,src.[total shift/week]
				,src.[roster - fte/week]
				,@batchID                                       AS [DWHBatchId]
				,CONVERT(DATETIME, '1 January 1900')            AS [DWHEffectiveFrom]
				,CONVERT(DATETIME, '31 December 2999 23:59:59') AS [DWHEffectiveTo]
				,'I'                                            AS [DWHDMLOperation]
				,1                                              AS [DWHIsCurrent]
				,@SourceSystem                                  AS [DWHSourceSystem]
			FROM [Staging].[ODSETLfact_sixdegree_roster] AS src;
		END ELSE BEGIN
			MERGE INTO [EDW].[fact_sixdegree_roster] AS trg
			USING
			(
				SELECT
					 src.[dim_service_key]
					,src.[entity_code]
					,src.[entity_parent_code]
					,src.[roster_shifts]
					,src.[monday]
					,src.[tuesday]
					,src.[wednesday]
					,src.[thursday]
					,src.[friday]
					,src.[saturday]
					,src.[sunday]
					,src.[total shift/week]
					,src.[roster - fte/week]
					,@batchID                                       AS [DWHBatchId]
					,CONVERT(DATETIME, '1 January 1900')            AS [DWHEffectiveFrom]
					,CONVERT(DATETIME, '31 December 2999 23:59:59') AS [DWHEffectiveTo]
					,'I'                                            AS [DWHDMLOperation]
					,1                                              AS [DWHIsCurrent]
					,@SourceSystem                                  AS [DWHSourceSystem]
				FROM [Staging].[ODSETLfact_sixdegree_roster] AS src
			) AS src ON (
				    src.[entity_code]   = trg.[entity_code]
				AND src.[roster_shifts] = trg.[roster_shifts] COLLATE database_default
				AND trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo
			)
			-- Retire existing records where data has changed
			WHEN MATCHED AND EXISTS
			(
				SELECT src.[dim_service_key], src.[entity_code], src.[entity_parent_code], src.[monday], src.[tuesday], src.[wednesday], src.[thursday], src.[friday], src.[saturday], src.[sunday], src.[total shift/week], src.[roster - fte/week], CASE WHEN trg.[DWHDMLOperation] = 'D' THEN 'U' ELSE 'X' END
				EXCEPT
				SELECT trg.[dim_service_key], trg.[entity_code], trg.[entity_parent_code], trg.[monday], trg.[tuesday], trg.[wednesday], trg.[thursday], trg.[friday], trg.[saturday], trg.[sunday], trg.[total shift/week], trg.[roster - fte/week], 'X'
			) THEN UPDATE SET [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Soft delete missing records
			WHEN NOT MATCHED BY SOURCE
				AND trg.[DWHEffectiveTo]   = @SystemDefaultEffectiveTo
				AND trg.[DWHDMLOperation] <> 'D'
			THEN UPDATE SET [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Insert new records
			WHEN NOT MATCHED BY TARGET THEN
				INSERT
				(
					 [dim_service_key]
					,[entity_code]
					,[entity_parent_code]
					,[roster_shifts]
					,[monday]
					,[tuesday]
					,[wednesday]
					,[thursday]
					,[friday]
					,[saturday]
					,[sunday]
					,[total shift/week]
					,[roster - fte/week]
					,[DWHBatchId]
					,[DWHEffectiveFrom]
					,[DWHEffectiveTo]
					,[DWHDMLOperation]
					,[DWHIsCurrent]
					,[DWHSourceSystem]
				)
				VALUES
				(
					 src.[dim_service_key]
					,src.[entity_code]
					,src.[entity_parent_code]
					,src.[roster_shifts]
					,src.[monday]
					,src.[tuesday]
					,src.[wednesday]
					,src.[thursday]
					,src.[friday]
					,src.[saturday]
					,src.[sunday]
					,src.[total shift/week]
					,src.[roster - fte/week]
					,src.[DWHBatchId]
					,src.[DWHEffectiveFrom]
					,src.[DWHEffectiveTo]
					,src.[DWHDMLOperation]
					,src.[DWHIsCurrent]
					,src.[DWHSourceSystem]
				)
			OUTPUT
				COALESCE(src.[entity_code],   inserted.[entity_code]),
				COALESCE(src.[roster_shifts], inserted.[roster_shifts]),
				$ACTION AS [MergeAction]
			INTO #SummaryOfChanges;

			-- Insert new versions of previously updated and deleted records
			INSERT INTO [EDW].[fact_sixdegree_roster]
			(
				 [dim_service_key]
				,[entity_code]
				,[entity_parent_code]
				,[roster_shifts]
				,[monday]
				,[tuesday]
				,[wednesday]
				,[thursday]
				,[friday]
				,[saturday]
				,[sunday]
				,[total shift/week]
				,[roster - fte/week]
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
			)
			SELECT
				 src.[dim_service_key]
				,src.[entity_code]
				,src.[entity_parent_code]
				,src.[roster_shifts]
				,src.[monday]
				,src.[tuesday]
				,src.[wednesday]
				,src.[thursday]
				,src.[friday]
				,src.[saturday]
				,src.[sunday]
				,src.[total shift/week]
				,src.[roster - fte/week]
				,@batchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,@SourceSystem
				,'U'
			FROM #SummaryOfChanges AS base
			INNER JOIN [Staging].[ODSETLfact_sixdegree_roster] AS src
				ON  src.[entity_code]   = base.[entity_code]
				AND src.[roster_shifts] = base.[roster_shifts] COLLATE database_default
			WHERE base.[MergeAction] = 'UPDATE'

			UNION ALL

			SELECT
				 tbl.[dim_service_key]
				,tbl.[entity_code]
				,tbl.[entity_parent_code]
				,tbl.[roster_shifts]
				,tbl.[monday]
				,tbl.[tuesday]
				,tbl.[wednesday]
				,tbl.[thursday]
				,tbl.[friday]
				,tbl.[saturday]
				,tbl.[sunday]
				,tbl.[total shift/week]
				,tbl.[roster - fte/week]
				,@batchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,@SourceSystem
				,'D'
			FROM #SummaryOfChanges AS base
			INNER JOIN [EDW].[fact_sixdegree_roster] AS tbl
				ON  tbl.[entity_code]   = base.[entity_code]
				AND tbl.[roster_shifts] = base.[roster_shifts] COLLATE database_default
				AND tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			LEFT JOIN [Staging].[ODSETLfact_sixdegree_roster] AS src
				ON  src.[entity_code]   = base.[entity_code]
				AND src.[roster_shifts] = base.[roster_shifts] COLLATE database_default
			WHERE base.[MergeAction] = 'UPDATE'
			  AND src.[entity_code]   IS NULL
			  AND src.[roster_shifts] IS NULL;
		END;

		-- Get process counts
		SELECT
			 @targetRecords   = COUNT(1)
			,@insertedRecords = SUM(CASE WHEN [DWHDMLOperation] = 'I' AND [DWHBatchId] = @batchID THEN 1 ELSE 0 END)
			,@updatedRecords  = ISNULL(@updatedRecords, 0) + SUM(CASE WHEN [DWHDMLOperation] = 'U' AND [DWHBatchId] = @batchID THEN 1 ELSE 0 END)
			,@deletedRecords  = SUM(CASE WHEN [DWHDMLOperation] = 'D' AND [DWHBatchId] = @batchID THEN 1 ELSE 0 END)
		FROM [EDW].[fact_sixdegree_roster]
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
