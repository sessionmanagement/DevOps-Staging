--drop procedure [edw].[Updateedwdim_property_arrears_arrangement]
--go

/**********************************************************************************************************
 Procedure[edw].[Updateedwdim_property_arrears_arrangement]
 AuthorGitHub Copilot
 Created2026-02-20
 PurposeUpdates the dim_property_arrears_arrangement table from staging

 Notes: Call ByEDW Pipeline
 =========================================================================================================

REVISIONS:
Version Date   Author    Description
-------------------  --------------------------------------------
1.0     2026-02-20    GitHub Copilot      Removed redundant columns (breach_id, breach) per work item 12210
**********************************************************************************************************/

create   procedure [edw].[Updateedwdim_property_arrears_arrangement] @pBatchID INT
	,@pIndexRebuildThreshold INT
	,@pOutputParamsAsDataset INT = 0
	,@pErrorRecords INT = NULL OUTPUT
	,@pInsertRecords INT = NULL OUTPUT
	,@pUpdateRecords INT = NULL OUTPUT
	,@pDeleteRecords INT = NULL OUTPUT
	,@pCompleted INT = NULL OUTPUT
	,@pTargetRecords INT = NULL OUTPUT
	,@pErrorMessage VARCHAR(MAX) = NULL OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	-- Variables   
	DECLARE @batchID INT = @pBatchID;
	DECLARE @SourceSystem NVARCHAR(120) = '[Staging].[ODSETLdim_property_arrears_arrangement]';
	DECLARE @stagedRecords INT = 0;
	DECLARE @targetRecords INT = 0;
	DECLARE @insertedRecords INT = 0;
	DECLARE @updatedRecords INT = 0;
	DECLARE @deletedRecords INT = 0;
	DECLARE @systemCurrentDate DATETIME = getdate();
	DECLARE @SystemEffectiveFrom DATETIME = @systemCurrentDate;
	DECLARE @SystemEffectiveTo DATETIME = dateadd(second, - 1, @SystemEffectiveFrom);
	DECLARE @SystemDefaultEffectiveFrom DATETIME = '1 January 1900';
	DECLARE @SystemDefaultEffectiveTo DATETIME = '31 December 2999 23:59:59';

	IF (object_id('tempdb..#SummaryOfChanges') IS NOT NULL)
		DROP TABLE #SummaryOfChanges;

	CREATE TABLE #SummaryOfChanges (
		[property_arrears_arrangement_id] UNIQUEIDENTIFIER NULL
		,[MergeAction] VARCHAR(10)
		);

	BEGIN TRANSACTION;

	BEGIN TRY
		-- Do not run if there are no records in source    
		SELECT @stagedRecords = count(1)
		FROM [Staging].[ODSETLdim_property_arrears_arrangement];

		IF (@stagedRecords = 0)
		BEGIN
			SELECT @targetRecords = count(1)
				,@deletedRecords = sum(CASE 
						WHEN [DWHDMLOperation] = 'D'
							AND [DWHBatchId] = @BatchID
							THEN 1
						ELSE 0
						END)
			FROM [edw].[dim_property_arrears_arrangement];

			-- Select success details     
			SELECT @pErrorRecords = 0
				,@pInsertRecords = 0
				,@pUpdateRecords = 0
				,@pDeleteRecords = 0
				,@pCompleted = 1
				,@pTargetRecords = @targetRecords;

			IF (@pOutputParamsAsDataset = 1)
			BEGIN
				-- Select return parameters as a dataset      
				SELECT @pErrorRecords AS ErrorRecords
					,@pInsertRecords AS InsertRecords
					,@pUpdateRecords AS UpdateRecords
					,@pDeleteRecords AS DeleteRecords
					,@pCompleted AS Completed
					,@targetRecords AS TargetRecords
					,@pErrorMessage AS ErrorMessage;
			END;

			COMMIT TRANSACTION;

			RETURN;
		END;

		IF (
				NOT EXISTS (
					SELECT TOP (1) 1
					FROM [edw].[dim_property_arrears_arrangement]
					)
				)
		BEGIN
			-- There are no records in the target 	INSERT ALL

			INSERT INTO [edw].[dim_property_arrears_arrangement] (
				[property_arrears_arrangement_id]
				
				,dim_property_key
				,dim_property_program_key
				,dim_property_tenancy_key
				,[property_tenancy_id]
				,[property_id]
				,[property_program_id]
				,[property_subprogram_id]
				,[property]
				,[property_program]
				,[property_subprogram]
				
				
				,[tenancy_transaction_type_id]
				,[property_tenancy]
				,[transaction_type]
				,[arrears_arrangement_reference]
				,[arrears_arrangement]
				,[arrears_arrangement_priority]
				,[arrears_arrangement_type]
				,[arrears_arrangement_frequency]
				,[calculated_based_on]
				,[comments]
				,[start_date_id]
				,[end_date_id]
				,[first_payment_date_id]
				,[amount]
				,[balance_amount]
				,[managed_arrears]
				,[unmanaged_arrears]
				,[total_arrears]
				,[total_balance]
				,[owner_name]
				,[created_by_name]
				,[created_datetime]
				,[modified_by_name]
				,[modified_datetime]
				,[is_delete_flag]
				,[synapse_link_sink_modified_on]
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHDMLOperation]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				)
			SELECT src.[property_arrears_arrangement_id]
				,src.dim_property_key
				,src.dim_property_program_key
				,src.dim_property_tenancy_key
				,src.[property_tenancy_id]
				,src.[property_id]
				,src.[property_program_id]
				,src.[property_subprogram_id]
				,src.[property]
				,src.[property_program]
				,src.[property_subprogram]
				
				
				,src.[tenancy_transaction_type_id]
				,src.[property_tenancy]
				,src.[transaction_type]
				,src.[arrears_arrangement_reference]
				,src.[arrears_arrangement]
				,src.[arrears_arrangement_priority]
				,src.[arrears_arrangement_type]
				,src.[arrears_arrangement_frequency]
				,src.[calculated_based_on]
				,src.[comments]
				,src.[start_date_id]
				,src.[end_date_id]
				,src.[first_payment_date_id]
				,src.[amount]
				,src.[balance_amount]
				,src.[managed_arrears]
				,src.[unmanaged_arrears]
				,src.[total_arrears]
				,src.[total_balance]
				,src.[owner_name]
				,src.[created_by_name]
				,src.[created_datetime]
				,src.[modified_by_name]
				,src.[modified_datetime]
				,src.[is_delete_flag]
				,src.[synapse_link_sink_modified_on]
				,@BatchID AS [DWHBatchId]
				,convert(DATETIME, '1 January 1900') AS [DWHEffectiveFrom]
				,convert(DATETIME, '31 December 2999 23:59:59') AS [DWHEffectiveTo]
				,'I' AS [DWHDMLOperation]
				,1 AS [DWHIsCurrent]
				,@SourceSystem AS [DWHSourceSystem]
			FROM [Staging].[ODSETLdim_property_arrears_arrangement] AS src;
		END
		ELSE
		BEGIN
			-- Fetch the current high-water maximum values  
			DECLARE @property_arrears_arrangement_datetime DATETIME2(7) = NULL;

			EXECUTE [edw].[GetHighwaterForedwdim_property_arrears_arrangement] @property_arrears_arrangement_datetime OUTPUT;

			MERGE INTO [edw].[dim_property_arrears_arrangement] AS trg
			USING (
				SELECT src.[property_arrears_arrangement_id]
					,src.dim_property_key
					,src.dim_property_program_key
					,src.dim_property_tenancy_key
					,src.[property_tenancy_id]
					,src.[property_id]
					,src.[property_program_id]
					,src.[property_subprogram_id]
					,src.[property]
					,src.[property_program]
					,src.[property_subprogram]
					
					
					,src.[tenancy_transaction_type_id]
					,src.[property_tenancy]
					,src.[transaction_type]
					,src.[arrears_arrangement_reference]
					,src.[arrears_arrangement]
					,src.[arrears_arrangement_priority]
					,src.[arrears_arrangement_type]
					,src.[arrears_arrangement_frequency]
					,src.[calculated_based_on]
					,src.[comments]
					,src.[start_date_id]
					,src.[end_date_id]
					,src.[first_payment_date_id]
					,src.[amount]
					,src.[balance_amount]
					,src.[managed_arrears]
					,src.[unmanaged_arrears]
					,src.[total_arrears]
					,src.[total_balance]
					,src.[owner_name]
					,src.[created_by_name]
					,src.[created_datetime]
					,src.[modified_by_name]
					,src.[modified_datetime]
					,src.[is_delete_flag]
					,src.[synapse_link_sink_modified_on]
					,@BatchID AS [DWHBatchId]
					,convert(DATETIME, '1 January 1900') AS [DWHEffectiveFrom]
					,convert(DATETIME, '31 December 2999 23:59:59') AS [DWHEffectiveTo]
					,'I' AS [DWHDMLOperation]
					,1 AS [DWHIsCurrent]
					,@SourceSystem AS [DWHSourceSystem]
				FROM [Staging].[ODSETLdim_property_arrears_arrangement] AS src
				) AS src
				ON (
						src.[property_arrears_arrangement_id] = trg.[property_arrears_arrangement_id]
						AND trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo
						)
					-- Retire existing records 
			WHEN MATCHED
				AND EXISTS (
					SELECT src.[property_tenancy_id]
						,src.dim_property_key
						,src.dim_property_program_key
						,src.dim_property_tenancy_key
						,src.[property_id]
						,src.[property_program_id]
						,src.[property_subprogram_id]
						,src.[property]
						,src.[property_program]
						,src.[property_subprogram]
						
						
						,src.[tenancy_transaction_type_id]
						,src.[property_tenancy]
						,src.[transaction_type]
						,src.[arrears_arrangement_reference]
						,src.[arrears_arrangement]
						,src.[arrears_arrangement_priority]
						,src.[arrears_arrangement_type]
						,src.[arrears_arrangement_frequency]
						,src.[calculated_based_on]
						,src.[comments]
						,src.[start_date_id]
						,src.[end_date_id]
						,src.[first_payment_date_id]
						,src.[amount]
						,src.[balance_amount]
						,src.[managed_arrears]
						,src.[unmanaged_arrears]
						,src.[total_arrears]
						,src.[total_balance]
						,src.[owner_name]
						,src.[created_by_name]
						,src.[created_datetime]
						,src.[modified_by_name]
						,src.[modified_datetime]
						,src.[is_delete_flag]
						,src.[synapse_link_sink_modified_on]
						,CASE 
							WHEN trg.[DWHDMLOperation] = 'D'
								THEN 'U'
							ELSE 'X'
							END
					
					EXCEPT
					
					SELECT trg.[property_tenancy_id]
						,trg.dim_property_key
						,trg.dim_property_program_key
						,trg.dim_property_tenancy_key
						,trg.[property_id]
						,trg.[property_program_id]
						,trg.[property_subprogram_id]
						,trg.[property]
						,trg.[property_program]
						,trg.[property_subprogram]
						
						
						,trg.[tenancy_transaction_type_id]
						,trg.[property_tenancy]
						,trg.[transaction_type]
						,trg.[arrears_arrangement_reference]
						,trg.[arrears_arrangement]
						,trg.[arrears_arrangement_priority]
						,trg.[arrears_arrangement_type]
						,trg.[arrears_arrangement_frequency]
						,trg.[calculated_based_on]
						,trg.[comments]
						,trg.[start_date_id]
						,trg.[end_date_id]
						,trg.[first_payment_date_id]
						,trg.[amount]
						,trg.[balance_amount]
						,trg.[managed_arrears]
						,trg.[unmanaged_arrears]
						,trg.[total_arrears]
						,trg.[total_balance]
						,trg.[owner_name]
						,trg.[created_by_name]
						,trg.[created_datetime]
						,trg.[modified_by_name]
						,trg.[modified_datetime]
						,trg.[is_delete_flag]
						,trg.[synapse_link_sink_modified_on]
						,'X'
					)
				THEN
					UPDATE
					SET [DWHEffectiveTo] = @SystemEffectiveTo
						,[DWHIsCurrent] = 0
						-- Soft delete missing records     
			WHEN NOT MATCHED BY source
				AND trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo
				AND trg.[DWHDMLOperation] <> 'D'
				AND trg.[modified_datetime] > @property_arrears_arrangement_datetime
				THEN
					UPDATE
					SET [DWHEffectiveTo] = @SystemEffectiveTo
						,[DWHIsCurrent] = 0
						-- Insert new records     
			WHEN NOT MATCHED BY target
				THEN
					INSERT (
						[property_arrears_arrangement_id]
						,dim_property_key
						,dim_property_program_key
						,dim_property_tenancy_key
						,[property_tenancy_id]
						,[property_id]
						,[property_program_id]
						,[property_subprogram_id]
						,[property]
						,[property_program]
						,[property_subprogram]
						
						
						,[tenancy_transaction_type_id]
						,[property_tenancy]
						,[transaction_type]
						,[arrears_arrangement_reference]
						,[arrears_arrangement]
						,[arrears_arrangement_priority]
						,[arrears_arrangement_type]
						,[arrears_arrangement_frequency]
						,[calculated_based_on]
						,[comments]
						,[start_date_id]
						,[end_date_id]
						,[first_payment_date_id]
						,[amount]
						,[balance_amount]
						,[managed_arrears]
						,[unmanaged_arrears]
						,[total_arrears]
						,[total_balance]
						,[owner_name]
						,[created_by_name]
						,[created_datetime]
						,[modified_by_name]
						,[modified_datetime]
						,[is_delete_flag]
						,[synapse_link_sink_modified_on]
						,[DWHBatchId]
						,[DWHEffectiveFrom]
						,[DWHEffectiveTo]
						,[DWHDMLOperation]
						,[DWHIsCurrent]
						,[DWHSourceSystem]
						)
					VALUES (
						src.[property_arrears_arrangement_id]
						,src.dim_property_key
						,src.dim_property_program_key
						,src.dim_property_tenancy_key
						,src.[property_tenancy_id]
						,src.[property_id]
						,src.[property_program_id]
						,src.[property_subprogram_id]
						,src.[property]
						,src.[property_program]
						,src.[property_subprogram]
						
						
						,src.[tenancy_transaction_type_id]
						,src.[property_tenancy]
						,src.[transaction_type]
						,src.[arrears_arrangement_reference]
						,src.[arrears_arrangement]
						,src.[arrears_arrangement_priority]
						,src.[arrears_arrangement_type]
						,src.[arrears_arrangement_frequency]
						,src.[calculated_based_on]
						,src.[comments]
						,src.[start_date_id]
						,src.[end_date_id]
						,src.[first_payment_date_id]
						,src.[amount]
						,src.[balance_amount]
						,src.[managed_arrears]
						,src.[unmanaged_arrears]
						,src.[total_arrears]
						,src.[total_balance]
						,src.[owner_name]
						,src.[created_by_name]
						,src.[created_datetime]
						,src.[modified_by_name]
						,src.[modified_datetime]
						,src.[is_delete_flag]
						,src.[synapse_link_sink_modified_on]
						,src.[DWHBatchId]
						,src.[DWHEffectiveFrom]
						,src.[DWHEffectiveTo]
						,src.[DWHDMLOperation]
						,src.[DWHIsCurrent]
						,src.[DWHSourceSystem]
						)
			OUTPUT coalesce(src.[property_arrears_arrangement_id], inserted.[property_arrears_arrangement_id])
				,$ACTION AS [MergeAction]
			INTO #SummaryOfChanges;

			-- Insert new versions of previously updated records (Updates and Deletes)     
			INSERT INTO [edw].[dim_property_arrears_arrangement] (
				[property_arrears_arrangement_id]
				,dim_property_key
				,dim_property_program_key
				,dim_property_tenancy_key
				,[property_tenancy_id]
				,[property_id]
				,[property_program_id]
				,[property_subprogram_id]
				,[property]
				,[property_program]
				,[property_subprogram]
				
				
				,[tenancy_transaction_type_id]
				,[property_tenancy]
				,[transaction_type]
				,[arrears_arrangement_reference]
				,[arrears_arrangement]
				,[arrears_arrangement_priority]
				,[arrears_arrangement_type]
				,[arrears_arrangement_frequency]
				,[calculated_based_on]
				,[comments]
				,[start_date_id]
				,[end_date_id]
				,[first_payment_date_id]
				,[amount]
				,[balance_amount]
				,[managed_arrears]
				,[unmanaged_arrears]
				,[total_arrears]
				,[total_balance]
				,[owner_name]
				,[created_by_name]
				,[created_datetime]
				,[modified_by_name]
				,[modified_datetime]
				,[is_delete_flag]
				,[synapse_link_sink_modified_on]
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
				)
			SELECT src.[property_arrears_arrangement_id]
				,src.dim_property_key
				,src.dim_property_program_key
				,src.dim_property_tenancy_key
				,src.[property_tenancy_id]
				,src.[property_id]
				,src.[property_program_id]
				,src.[property_subprogram_id]
				,src.[property]
				,src.[property_program]
				,src.[property_subprogram]
				
				
				,src.[tenancy_transaction_type_id]
				,src.[property_tenancy]
				,src.[transaction_type]
				,src.[arrears_arrangement_reference]
				,src.[arrears_arrangement]
				,src.[arrears_arrangement_priority]
				,src.[arrears_arrangement_type]
				,src.[arrears_arrangement_frequency]
				,src.[calculated_based_on]
				,src.[comments]
				,src.[start_date_id]
				,src.[end_date_id]
				,src.[first_payment_date_id]
				,src.[amount]
				,src.[balance_amount]
				,src.[managed_arrears]
				,src.[unmanaged_arrears]
				,src.[total_arrears]
				,src.[total_balance]
				,src.[owner_name]
				,src.[created_by_name]
				,src.[created_datetime]
				,src.[modified_by_name]
				,src.[modified_datetime]
				,src.[is_delete_flag]
				,src.[synapse_link_sink_modified_on]
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLdim_property_arrears_arrangement]'
				,'U'
			FROM #SummaryOfChanges AS base
			INNER JOIN [Staging].[ODSETLdim_property_arrears_arrangement] AS src ON src.[property_arrears_arrangement_id] = base.[property_arrears_arrangement_id]
			WHERE base.[MergeAction] = 'UPDATE'
			
			UNION ALL
			
			SELECT tbl.[property_arrears_arrangement_id]
				,tbl.dim_property_key
				,tbl.dim_property_program_key
				,tbl.dim_property_tenancy_key
				,tbl.[property_tenancy_id]
				,tbl.[property_id]
				,tbl.[property_program_id]
				,tbl.[property_subprogram_id]
				,tbl.[property]
				,tbl.[property_program]
				,tbl.[property_subprogram]
				
				
				,tbl.[tenancy_transaction_type_id]
				,tbl.[property_tenancy]
				,tbl.[transaction_type]
				,tbl.[arrears_arrangement_reference]
				,tbl.[arrears_arrangement]
				,tbl.[arrears_arrangement_priority]
				,tbl.[arrears_arrangement_type]
				,tbl.[arrears_arrangement_frequency]
				,tbl.[calculated_based_on]
				,tbl.[comments]
				,tbl.[start_date_id]
				,tbl.[end_date_id]
				,tbl.[first_payment_date_id]
				,tbl.[amount]
				,tbl.[balance_amount]
				,tbl.[managed_arrears]
				,tbl.[unmanaged_arrears]
				,tbl.[total_arrears]
				,tbl.[total_balance]
				,tbl.[owner_name]
				,tbl.[created_by_name]
				,tbl.[created_datetime]
				,tbl.[modified_by_name]
				,tbl.[modified_datetime]
				,tbl.[is_delete_flag]
				,tbl.[synapse_link_sink_modified_on]
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLdim_property_arrears_arrangement]'
				,'D'
			FROM #SummaryOfChanges AS base
			INNER JOIN [edw].[dim_property_arrears_arrangement] AS tbl ON tbl.[property_arrears_arrangement_id] = base.[property_arrears_arrangement_id]
				AND tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			LEFT JOIN [Staging].[ODSETLdim_property_arrears_arrangement] AS src ON src.[property_arrears_arrangement_id] = base.[property_arrears_arrangement_id]
			WHERE base.[MergeAction] = 'UPDATE'
				AND src.[property_arrears_arrangement_id] IS NULL;
		END;

		-- Get process counts    
		SELECT @targetRecords = count(1)
			,@insertedRecords = sum(CASE 
					WHEN [DWHDMLOperation] = 'I'
						AND [DWHBatchId] = @BatchID
						THEN 1
					ELSE 0
					END)
			,@updatedRecords = isnull(@updatedRecords, 0) + sum(CASE 
					WHEN [DWHDMLOperation] = 'U'
						AND [DWHBatchId] = @BatchID
						THEN 1
					ELSE 0
					END)
			,@deletedRecords = sum(CASE 
					WHEN [DWHDMLOperation] = 'D'
						AND [DWHBatchId] = @BatchID
						THEN 1
					ELSE 0
					END)
		FROM [edw].[dim_property_arrears_arrangement]
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
			SELECT @pErrorRecords AS ErrorRecords
				,@pInsertRecords AS InsertRecords
				,@pUpdateRecords AS UpdateRecords
				,@pDeleteRecords AS DeleteRecords
				,@pCompleted AS Completed
				,@targetRecords AS TargetRecords
				,@pErrorMessage AS ErrorMessage;
		END;

		throw;
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
		SELECT @pErrorRecords AS ErrorRecords
			,@pInsertRecords AS InsertRecords
			,@pUpdateRecords AS UpdateRecords
			,@pDeleteRecords AS DeleteRecords
			,@pCompleted AS Completed
			,@targetRecords AS TargetRecords
			,@pErrorMessage AS ErrorMessage;
	END;
END;