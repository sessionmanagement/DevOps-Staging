CREATE PROCEDURE [edw].[Updateedwdim_webexpense] 
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
/***************************************************************************
NAME:    [edw].[Updateedwdim_webexpense]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-12-12    ?				Initial version
1.1		 2025-12-05    Malhar Badheka	Updated to include dim_expenses_key and DWH prefix
1.2		 2026-01-22    Malhar Badheka	changes to variable to source system & dim keys -1 and 0 added 
1.3		 2026-04-09    Malhar Badheka	Added receipt_available_flag column (us #13162)

****************************************************************************/

BEGIN

	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	-- Variables
	DECLARE @batchID INT = @pBatchID;
	DECLARE @SourceSystem NVARCHAR(120) = '[ETL].[dim_webexpense]';
	
	DECLARE @stagedRecords INT = 0;
	DECLARE @targetRecords INT = 0;
	
	DECLARE @insertedRecords INT = 0;
	DECLARE @updatedRecords INT = 0;
	DECLARE @deletedRecords INT = 0;
	
	DECLARE @systemCurrentDate DATETIME = GETDATE();

	DECLARE @SystemEffectiveFrom DATETIME = @systemCurrentDate;
	DECLARE @SystemEffectiveTo DATETIME = DATEADD(second,-1,@SystemEffectiveFrom);
	DECLARE @SystemDefaultEffectiveFrom DATETIME = '1 January 1900';
	DECLARE @SystemDefaultEffectiveTo DATETIME = '31 December 2999 23:59:59';

	-- Do not run if there are no records in source
	SELECT @stagedRecords = COUNT(1) FROM [Staging].[ODSETLdim_webexpense];
	IF( @stagedRecords = 0 )
	BEGIN
		SELECT @targetRecords = COUNT(1) FROM [edw].[dim_webexpense];

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
					@pErrorMessage AS ErrorMessage;
		END;

		RETURN;
	END;

	IF( OBJECT_ID( 'tempdb..#SummaryOfChanges') IS NOT NULL ) DROP TABLE #SummaryOfChanges;
	CREATE TABLE #SummaryOfChanges
	(	
		 [expense_key] NVARCHAR(62) NOT NULL
		,[user_id] INT NULL
		,[MergeAction] VARCHAR(10)
	);
	BEGIN TRANSACTION;

		IF NOT EXISTS (SELECT dim_webexpense_key FROM edw.dim_webexpense WHERE [dim_webexpense_key] <= 0)
		BEGIN
			-- turn the identity insert on 
			SET IDENTITY_INSERT edw.dim_webexpense ON

			INSERT INTO edw.dim_webexpense
			(
				[dim_webexpense_key],
				[expense_key],
				[claim_number],
				[user_id],
				[claimant_login],
				[claimant_name],
				[approver_login],
				[approver_name],
				[company],
				[cost_center_id],
				[category_id],
				[category_name],
				[gl_code],
				[description],
				[status],
				[source],
				[currency_code],
				[billing_currency],
				[receipt_available_flag],
				[DWHBatchId],
				[DWHEffectiveFrom],
				[DWHEffectiveTo],
				[DWHDMLOperation],
				[DWHIsCurrent],
				[DWHSourceSystem]
			)
			VALUES
			(0, '0', 0, 0, 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 0, 0, 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 0, @SystemDefaultEffectiveFrom, @SystemDefaultEffectiveTo, 'I', 1, @SourceSystem),
			(-1, '-1', -1, -1, 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', -1, -1, 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'Unknown', 0, @SystemDefaultEffectiveFrom, @SystemDefaultEffectiveTo, 'I', 1, @SourceSystem)

			-- turn the identity insert off
			SET IDENTITY_INSERT edw.dim_webexpense OFF
		END

	BEGIN TRY
		IF( NOT EXISTS (SELECT TOP(1) 1 FROM [edw].[dim_webexpense]) )
		BEGIN
			-- There are no records in the target; insert all
			INSERT INTO [edw].[dim_webexpense]
			(
				 [expense_key] 
				,[claim_number] 
				,[user_id] 
				,[claimant_login] 
				,[claimant_name] 
				,[approver_login] 
				,[approver_name] 
				,[company] 
				,[cost_center_id] 
				,[category_id] 
				,[category_name] 
				,[gl_code] 
				,[description] 
				,[status] 
				,[source] 
				,[currency_code] 
				,[billing_currency] 
				,[receipt_available_flag] 
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
			)
			SELECT
				 src.[expense_key] 
				,src.[claim_number] 
				,src.[user_id] 
				,src.[claimant_login] 
				,src.[claimant_name] 
				,src.[approver_login] 
				,src.[approver_name] 
				,src.[company] 
				,src.[cost_center_id] 
				,src.[category_id] 
				,src.[category_name] 
				,src.[gl_code] 
				,src.[description] 
				,src.[status] 
				,src.[source] 
				,src.[currency_code] 
				,src.[billing_currency] 
				,src.[receipt_available_flag] 
				,@BatchID AS [DWHBatchId]
				,CONVERT(DATETIME,'1 January 1900') AS [DWHEffectiveFrom]
				,CONVERT(DATETIME,'31 December 2999 23:59:59') AS [DWHEffectiveTo]
				,'I' AS [DWHDMLOperation]
				,1 AS [DWHIsCurrent]
				,@SourceSystem AS [DWHSourceSystem]
			FROM [Staging].[ODSETLdim_webexpense] AS src;
		END ELSE BEGIN
			MERGE INTO [edw].[dim_webexpense] AS trg
			USING 
			(
				SELECT
				 src.[expense_key] 
				,src.[claim_number] 
				,src.[user_id] 
				,src.[claimant_login] 
				,src.[claimant_name] 
				,src.[approver_login] 
				,src.[approver_name] 
				,src.[company] 
				,src.[cost_center_id] 
				,src.[category_id] 
				,src.[category_name] 
				,src.[gl_code] 
				,src.[description] 
				,src.[status] 
				,src.[source] 
				,src.[currency_code] 
				,src.[billing_currency] 
				,src.[receipt_available_flag] 
				,@BatchID AS [DWHBatchId]
				,CONVERT(DATETIME,'1 January 1900') AS [DWHEffectiveFrom]
				,CONVERT(DATETIME,'31 December 2999 23:59:59') AS [DWHEffectiveTo]
				,'I' AS [DWHDMLOperation]
				,1 AS [DWHIsCurrent]
				,@SourceSystem AS [DWHSourceSystem]
				FROM [Staging].[ODSETLdim_webexpense] AS src
			) AS src ON (src.[expense_key] = trg.[expense_key] COLLATE database_default AND src.[user_id] = trg.[user_id] AND trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)
			-- Retire existing records
			WHEN MATCHED AND EXISTS 
			( 
				SELECT src.[claim_number], src.[claimant_login], src.[claimant_name], src.[approver_login], src.[approver_name], src.[company], src.[cost_center_id], src.[category_id], src.[category_name], src.[gl_code], src.[description], src.[status], src.[source], src.[currency_code], src.[billing_currency], src.[receipt_available_flag], CASE WHEN trg.[DWHDMLOperation] = 'D' THEN 'U' ELSE 'X' END
				EXCEPT
				SELECT trg.[claim_number], trg.[claimant_login], trg.[claimant_name], trg.[approver_login], trg.[approver_name], trg.[company], trg.[cost_center_id], trg.[category_id], trg.[category_name], trg.[gl_code], trg.[description], trg.[status], trg.[source], trg.[currency_code], trg.[billing_currency], trg.[receipt_available_flag], 'X'
			) THEN UPDATE SET [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Soft delete missing records
			WHEN NOT MATCHED BY SOURCE AND trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo AND trg.[DWHDMLOperation] <> 'D' THEN UPDATE SET [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Insert new records
			WHEN NOT MATCHED BY TARGET THEN 
				INSERT 
				(
					 [expense_key] 
					,[claim_number] 
					,[user_id] 
					,[claimant_login] 
					,[claimant_name] 
					,[approver_login] 
					,[approver_name] 
					,[company] 
					,[cost_center_id] 
					,[category_id] 
					,[category_name] 
					,[gl_code] 
					,[description] 
					,[status] 
					,[source] 
					,[currency_code] 
					,[billing_currency] 
					,[receipt_available_flag] 
					,[DWHBatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperation] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 
				)
				VALUES
				(
					 src.[expense_key] 
					,src.[claim_number] 
					,src.[user_id] 
					,src.[claimant_login] 
					,src.[claimant_name] 
					,src.[approver_login] 
					,src.[approver_name] 
					,src.[company] 
					,src.[cost_center_id] 
					,src.[category_id] 
					,src.[category_name] 
					,src.[gl_code] 
					,src.[description] 
					,src.[status] 
					,src.[source] 
					,src.[currency_code] 
					,src.[billing_currency] 
					,src.[receipt_available_flag] 
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			OUTPUT COALESCE(src.[expense_key],inserted.[expense_key]), COALESCE(src.[user_id],inserted.[user_id]), $action AS [MergeAction] INTO #SummaryOfChanges;

			-- Insert new versions of previously updated records (Updates and Deletes)
			INSERT INTO [edw].[dim_webexpense]
			(
				 [expense_key] 
				,[claim_number] 
				,[user_id] 
				,[claimant_login] 
				,[claimant_name] 
				,[approver_login] 
				,[approver_name] 
				,[company] 
				,[cost_center_id] 
				,[category_id] 
				,[category_name] 
				,[gl_code] 
				,[description] 
				,[status] 
				,[source] 
				,[currency_code] 
				,[billing_currency] 
				,[receipt_available_flag]
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
			)
			SELECT
				 src.[expense_key] 
				,src.[claim_number] 
				,src.[user_id] 
				,src.[claimant_login] 
				,src.[claimant_name] 
				,src.[approver_login] 
				,src.[approver_name] 
				,src.[company] 
				,src.[cost_center_id] 
				,src.[category_id] 
				,src.[category_name] 
				,src.[gl_code] 
				,src.[description] 
				,src.[status] 
				,src.[source] 
				,src.[currency_code] 
				,src.[billing_currency] 
				,src.[receipt_available_flag]
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,@SourceSystem
				,'U'
			FROM #SummaryOfChanges AS base
			INNER JOIN [Staging].[ODSETLdim_webexpense] AS src ON src.[expense_key] = base.[expense_key] COLLATE database_default AND src.[user_id] = base.[user_id]
			WHERE base.[MergeAction] = 'UPDATE'

			UNION ALL 

			SELECT
				 tbl.[expense_key] 
				,tbl.[claim_number] 
				,tbl.[user_id] 
				,tbl.[claimant_login] 
				,tbl.[claimant_name] 
				,tbl.[approver_login] 
				,tbl.[approver_name] 
				,tbl.[company] 
				,tbl.[cost_center_id] 
				,tbl.[category_id] 
				,tbl.[category_name] 
				,tbl.[gl_code] 
				,tbl.[description] 
				,tbl.[status] 
				,tbl.[source] 
				,tbl.[currency_code] 
				,tbl.[billing_currency] 
				,tbl.[receipt_available_flag]
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,@SourceSystem
				,'D'
			FROM #SummaryOfChanges AS base
			INNER JOIN [edw].[dim_webexpense] AS tbl ON tbl.[expense_key] = base.[expense_key] COLLATE database_default AND tbl.[user_id] = base.[user_id] AND tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			LEFT JOIN [Staging].[ODSETLdim_webexpense] AS src ON src.[expense_key] = base.[expense_key] COLLATE database_default AND src.[user_id] = base.[user_id]
			WHERE base.[MergeAction] = 'UPDATE'
			AND src.[expense_key] IS NULL AND src.[user_id] IS NULL;
		END;

		-- Get process counts
		SELECT 
			 @targetRecords = COUNT(1) 
			,@insertedRecords = SUM( CASE WHEN [DWHDMLOperation] = 'I' AND [DWHBatchId] = @BatchID THEN 1 ELSE 0 END)
			,@updatedRecords = ISNULL(@updatedRecords,0) + SUM( CASE WHEN [DWHDMLOperation] = 'U' AND [DWHBatchId] = @BatchID THEN 1 ELSE 0 END)
			,@deletedRecords = SUM( CASE WHEN [DWHDMLOperation] = 'D' AND [DWHBatchId] = @BatchID THEN 1 ELSE 0 END)
		FROM [edw].[dim_webexpense]
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
					@pErrorMessage AS ErrorMessage;
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
				@pErrorMessage AS ErrorMessage;
	END;
END;
GO


