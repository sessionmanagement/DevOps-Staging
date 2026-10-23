










/**********************************************************************************************************
Procedure	[edw].[Updateedwdim_employee_hierarchy] 
Author		
Created		
Purpose		Move data from landing.dim_employee_hierarchy table into
			[staging].[ODSETLdim_employee_hierarchy] table
				

				
 Notes: Call By	EDW Pipeline '30_Load_From_ODS'
Parameter(s)  None 
=========================================================================================================

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		?			  ?						Initial creation of stored procedure.
1.1		2023-08-07	  Glenn McLeod			Updated to use table Framework table names.
												Fixed 0 record insert.
1.11	2023-08-21	  Glenn McLeod			Rename source tables
1.12	2023-08-23	  Glenn McLeod			Altered to stop 0 record [DWHEffectiveTo] from being update
1.13	2023-08-25	  Glenn McLeod			Updated table/column names
1.2		2023-09-25	  Glenn McLeod			Add -1 record of for Unknown and updated 0 record to be N/A
1.3		2023-11-27	  Glenn McLeod			Added role hierarchy fields


**********************************************************************************************************/


CREATE PROCEDURE [edw].[Updateedwdim_employee_hierarchy] @pBatchID INT
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
	DECLARE @SourceSystem NVARCHAR(120) = '[Staging].[ODSETLdim_employee_hierarchy]';
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
		[employee_id] INT NULL
		,[MergeAction] VARCHAR(10)
		);

	BEGIN TRANSACTION;

	BEGIN TRY


		IF NOT EXISTS (
				SELECT dim_employee_hierarchy_key
				FROM [edw].[dim_employee_hierarchy]
				WHERE [dim_employee_hierarchy_key] <= 0
				)
		BEGIN

			-- turn the identity insert on 
			SET IDENTITY_INSERT [edw].[dim_employee_hierarchy] ON

			INSERT INTO [edw].[dim_employee_hierarchy] (
				[dim_employee_hierarchy_key]
				,[dim_employee_key]
				,[employee_id]
				,[employee_primary_email_address]
				,[employee_company_name]
				,[employee_Business_unit_name]
				,[employee_displayname]
				,[employee_people_leader_employee_number_level_1]
				,[employee_people_leader_email_level_1]
				,[employee_people_leader_business_unit_name_level_1]
				,[employee_people_leader_person_display_name_level_1]
				,[employee_people_leader_role_name_level_1] 
				,[DWHSourceSystem]
				,[DWHBatchId]
				,[DWHDMLOperation]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				)
			VALUES (
				0
				,0
				,0
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,0
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'[edw].[dim_employee_hierarchy]'
				,0
				,'I'
				,@SystemDefaultEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				),
				(
				-1
				,-1
				,-1
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,-1
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'[edw].[dim_employee_hierarchy]'
				,0
				,'I'
				,@SystemDefaultEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				)

				-- turn the identity insert off
				SET IDENTITY_INSERT [edw].[dim_employee_hierarchy] OFF
		END


		-- Do not run if there are records in source
		SELECT @stagedRecords = count(1)
		FROM [Staging].[ODSETLdim_employee_hierarchy];

		IF (@stagedRecords = 0)
		BEGIN
			SELECT @targetRecords = count(1)
				,@deletedRecords = sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			FROM [edw].[dim_employee_hierarchy];

			-- Select success details   
			SELECT @pErrorRecords = 0
				,@pInsertRecords = 0
				,@pUpdateRecords = 0
				,@pDeleteRecords = 0
				,@pCompleted = 1
				,@pTargetRecords = @targetRecords;

			IF (@pOutputParamsAsDataset = 1)
			BEGIN -- Select return parameters as a dataset  
				SELECT @pErrorRecords AS ErrorRecords
					,@pInsertRecords AS InsertRecords
					,@pUpdateRecords AS UpdateRecords
					,@pDeleteRecords AS DeleteRecords
					,@pCompleted AS Completed
					,@targetRecords AS TargetRecords;
			END;

			RETURN;
		END;


		IF (
			NOT EXISTS (
				SELECT TOP (1) 1
				FROM [edw].[dim_employee_hierarchy] where dim_employee_hierarchy_key >0
				)
			)
		BEGIN -- There are no records in the target; insert all
			INSERT INTO [edw].[dim_employee_hierarchy] (
               [dim_employee_key],
                [employee_id],
                [employee_primary_email_address],
                [employee_company_name],
                [employee_Business_unit_name],
                [employee_displayname],
                [employee_people_leader_employee_number_level_1],
                [employee_people_leader_email_level_1],
                [employee_people_leader_business_unit_name_level_1],
                [employee_people_leader_person_display_name_level_1],
                [employee_people_leader_employee_number_level_2],
                [employee_people_leader_email_level_2],
                [employee_people_leader_business_unit_name_level_2],
                [employee_people_leader_person_display_name_level_2],
                [employee_people_leader_employee_number_level_3],
                [employee_people_leader_email_level_3],
                [employee_people_leader_business_unit_name_level_3],
                [employee_people_leader_person_display_name_level_3],
                [employee_people_leader_employee_number_level_4],
                [employee_people_leader_email_level_4],
                [employee_people_leader_business_unit_name_level_4],
                [employee_people_leader_person_display_name_level_4],
                [employee_people_leader_employee_number_level_5],
                [employee_people_leader_email_level_5],
                [employee_people_leader_business_unit_name_level_5],
                [employee_people_leader_person_display_name_level_5],
                [employee_people_leader_employee_number_level_6],
                [employee_people_leader_email_level_6],
                [employee_people_leader_business_unit_name_level_6],
                [employee_people_leader_person_display_name_level_6],
                [employee_people_leader_employee_number_level_7],
                [employee_people_leader_email_level_7],
                [employee_people_leader_business_unit_name_level_7],
                [employee_people_leader_person_display_name_level_7],
                [employee_people_leader_employee_number_level_8],
                [employee_people_leader_email_level_8],
                [employee_people_leader_business_unit_name_level_8],
                [employee_people_leader_person_display_name_level_8],
                [employee_people_leader_employee_number_level_9],
                [employee_people_leader_email_level_9],
                [employee_people_leader_business_unit_name_level_9],
                [employee_people_leader_person_display_name_level_9],
				[employee_people_leader_role_name_level_1],
				[employee_people_leader_role_name_level_2],
				[employee_people_leader_role_name_level_3],
				[employee_people_leader_role_name_level_4],
				[employee_people_leader_role_name_level_5],
				[employee_people_leader_role_name_level_6],
				[employee_people_leader_role_name_level_7],
				[employee_people_leader_role_name_level_8],
				[employee_people_leader_role_name_level_9],
                [DWHSourceSystem],
                [DWHBatchId],
                [DWHDMLOperation],
                [DWHEffectiveFrom],
                [DWHEffectiveTo],
                [DWHIsCurrent]
				)
                 Select src.[dim_employee_key],
					src.[employee_id],
					src.[employee_primary_email_address],
					src.[employee_company_name],
					src.[employee_Business_unit_name],
					src.[employee_displayname],
					src.[employee_people_leader_employee_number_level_1],
					src.[employee_people_leader_email_level_1],
					src.[employee_people_leader_business_unit_name_level_1],
					src.[employee_people_leader_person_display_name_level_1],
					src.[employee_people_leader_employee_number_level_2],
					src.[employee_people_leader_email_level_2],
					src.[employee_people_leader_business_unit_name_level_2],
					src.[employee_people_leader_person_display_name_level_2],
					src.[employee_people_leader_employee_number_level_3],
					src.[employee_people_leader_email_level_3],
					src.[employee_people_leader_business_unit_name_level_3],
					src.[employee_people_leader_person_display_name_level_3],
					src.[employee_people_leader_employee_number_level_4],
					src.[employee_people_leader_email_level_4],
					src.[employee_people_leader_business_unit_name_level_4],
					src.[employee_people_leader_person_display_name_level_4],
					src.[employee_people_leader_employee_number_level_5],
					src.[employee_people_leader_email_level_5],
					src.[employee_people_leader_business_unit_name_level_5],
					src.[employee_people_leader_person_display_name_level_5],
					src.[employee_people_leader_employee_number_level_6],
					src.[employee_people_leader_email_level_6],
					src.[employee_people_leader_business_unit_name_level_6],
					src.[employee_people_leader_person_display_name_level_6],
					src.[employee_people_leader_employee_number_level_7],
					src.[employee_people_leader_email_level_7],
					src.[employee_people_leader_business_unit_name_level_7],
					src.[employee_people_leader_person_display_name_level_7],
					src.[employee_people_leader_employee_number_level_8],
					src.[employee_people_leader_email_level_8],
					src.[employee_people_leader_business_unit_name_level_8],
					src.[employee_people_leader_person_display_name_level_8],
					src.[employee_people_leader_employee_number_level_9],
					src.[employee_people_leader_email_level_9],
					src.[employee_people_leader_business_unit_name_level_9],
					src.[employee_people_leader_person_display_name_level_9],
					src.[employee_people_leader_role_name_level_1],
					src.[employee_people_leader_role_name_level_2],
					src.[employee_people_leader_role_name_level_3],
					src.[employee_people_leader_role_name_level_4],
					src.[employee_people_leader_role_name_level_5],
					src.[employee_people_leader_role_name_level_6],
					src.[employee_people_leader_role_name_level_7],
					src.[employee_people_leader_role_name_level_8],
					src.[employee_people_leader_role_name_level_9],
					@SourceSystem as [DWHSourceSystem],
					@BatchID as [DWHBatchId],
					'I' as [DWHDMLOperation],
					convert(datetime, '1 January 1900') as [DWHEffectiveFrom],
					convert(datetime, '31 December 2999 23:59:59') as [DWHEffectiveTo],
					1 as [DWHIsCurrent]
            from [Staging].[ODSETLdim_employee_hierarchy] as src;
		END
		ELSE
		BEGIN

		MERGE INTO [edw].[dim_employee_hierarchy] AS trg
		USING (
			SELECT src.[dim_employee_key]
				,src.[employee_id]
				,src.[employee_primary_email_address]
				,src.[employee_company_name]
				,src.[employee_Business_unit_name]
				,src.[employee_displayname]
				,src.[employee_people_leader_employee_number_level_1]
				,src.[employee_people_leader_email_level_1]
				,src.[employee_people_leader_business_unit_name_level_1]
				,src.[employee_people_leader_person_display_name_level_1]
				,src.[employee_people_leader_employee_number_level_2]
				,src.[employee_people_leader_email_level_2]
				,src.[employee_people_leader_business_unit_name_level_2]
				,src.[employee_people_leader_person_display_name_level_2]
				,src.[employee_people_leader_employee_number_level_3]
				,src.[employee_people_leader_email_level_3]
				,src.[employee_people_leader_business_unit_name_level_3]
				,src.[employee_people_leader_person_display_name_level_3]
				,src.[employee_people_leader_employee_number_level_4]
				,src.[employee_people_leader_email_level_4]
				,src.[employee_people_leader_business_unit_name_level_4]
				,src.[employee_people_leader_person_display_name_level_4]
				,src.[employee_people_leader_employee_number_level_5]
				,src.[employee_people_leader_email_level_5]
				,src.[employee_people_leader_business_unit_name_level_5]
				,src.[employee_people_leader_person_display_name_level_5]
				,src.[employee_people_leader_employee_number_level_6]
				,src.[employee_people_leader_email_level_6]
				,src.[employee_people_leader_business_unit_name_level_6]
				,src.[employee_people_leader_person_display_name_level_6]
				,src.[employee_people_leader_employee_number_level_7]
				,src.[employee_people_leader_email_level_7]
				,src.[employee_people_leader_business_unit_name_level_7]
				,src.[employee_people_leader_person_display_name_level_7]
				,src.[employee_people_leader_employee_number_level_8]
				,src.[employee_people_leader_email_level_8]
				,src.[employee_people_leader_business_unit_name_level_8]
				,src.[employee_people_leader_person_display_name_level_8]
				,src.[employee_people_leader_employee_number_level_9]
				,src.[employee_people_leader_email_level_9]
				,src.[employee_people_leader_business_unit_name_level_9]
				,src.[employee_people_leader_person_display_name_level_9]
				,src.[employee_people_leader_role_name_level_1]
				,src.[employee_people_leader_role_name_level_2]
				,src.[employee_people_leader_role_name_level_3]
				,src.[employee_people_leader_role_name_level_4]
				,src.[employee_people_leader_role_name_level_5]
				,src.[employee_people_leader_role_name_level_6]
				,src.[employee_people_leader_role_name_level_7]
				,src.[employee_people_leader_role_name_level_8]
				,src.[employee_people_leader_role_name_level_9]
				,@SourceSystem AS [DWHSourceSystem]
				,@BatchID AS [DWHBatchId]
				,'I' AS [DWHDMLOperation]
				,convert(DATETIME, '1 January 1900') AS [DWHEffectiveFrom]
				,convert(DATETIME, '31 December 2999 23:59:59') AS [DWHEffectiveTo]
				,1 AS [DWHIsCurrent]
			FROM [Staging].[ODSETLdim_employee_hierarchy] AS src
			) AS src
			ON (
					src.[employee_id] = trg.[employee_id]
					AND trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo
					) -- Retire existing records
		WHEN MATCHED
			AND EXISTS (
				SELECT src.[dim_employee_key]
					,src.[employee_id]
					,src.[employee_primary_email_address]
					,src.[employee_company_name]
					,src.[employee_Business_unit_name]
					,src.[employee_displayname]
					,src.[employee_people_leader_employee_number_level_1]
					,src.[employee_people_leader_email_level_1]
					,src.[employee_people_leader_business_unit_name_level_1]
					,src.[employee_people_leader_person_display_name_level_1]
					,src.[employee_people_leader_employee_number_level_2]
					,src.[employee_people_leader_email_level_2]
					,src.[employee_people_leader_business_unit_name_level_2]
					,src.[employee_people_leader_person_display_name_level_2]
					,src.[employee_people_leader_employee_number_level_3]
					,src.[employee_people_leader_email_level_3]
					,src.[employee_people_leader_business_unit_name_level_3]
					,src.[employee_people_leader_person_display_name_level_3]
					,src.[employee_people_leader_employee_number_level_4]
					,src.[employee_people_leader_email_level_4]
					,src.[employee_people_leader_business_unit_name_level_4]
					,src.[employee_people_leader_person_display_name_level_4]
					,src.[employee_people_leader_employee_number_level_5]
					,src.[employee_people_leader_email_level_5]
					,src.[employee_people_leader_business_unit_name_level_5]
					,src.[employee_people_leader_person_display_name_level_5]
					,src.[employee_people_leader_employee_number_level_6]
					,src.[employee_people_leader_email_level_6]
					,src.[employee_people_leader_business_unit_name_level_6]
					,src.[employee_people_leader_person_display_name_level_6]
					,src.[employee_people_leader_employee_number_level_7]
					,src.[employee_people_leader_email_level_7]
					,src.[employee_people_leader_business_unit_name_level_7]
					,src.[employee_people_leader_person_display_name_level_7]
					,src.[employee_people_leader_employee_number_level_8]
					,src.[employee_people_leader_email_level_8]
					,src.[employee_people_leader_business_unit_name_level_8]
					,src.[employee_people_leader_person_display_name_level_8]
					,src.[employee_people_leader_employee_number_level_9]
					,src.[employee_people_leader_email_level_9]
					,src.[employee_people_leader_business_unit_name_level_9]
					,src.[employee_people_leader_person_display_name_level_9]
					,src.[employee_people_leader_role_name_level_1]
					,src.[employee_people_leader_role_name_level_2]
					,src.[employee_people_leader_role_name_level_3]
					,src.[employee_people_leader_role_name_level_4]
					,src.[employee_people_leader_role_name_level_5]
					,src.[employee_people_leader_role_name_level_6]
					,src.[employee_people_leader_role_name_level_7]
					,src.[employee_people_leader_role_name_level_8]
					,src.[employee_people_leader_role_name_level_9]
					,CASE 
						WHEN trg.[DWHDMLOperation] = 'D'
							THEN 'U'
						ELSE 'X'
						END
				
				EXCEPT
				
				SELECT trg.[dim_employee_key]
					,trg.[employee_id]
					,trg.[employee_primary_email_address]
					,trg.[employee_company_name]
					,trg.[employee_Business_unit_name]
					,trg.[employee_displayname]
					,trg.[employee_people_leader_employee_number_level_1]
					,trg.[employee_people_leader_email_level_1]
					,trg.[employee_people_leader_business_unit_name_level_1]
					,trg.[employee_people_leader_person_display_name_level_1]
					,trg.[employee_people_leader_employee_number_level_2]
					,trg.[employee_people_leader_email_level_2]
					,trg.[employee_people_leader_business_unit_name_level_2]
					,trg.[employee_people_leader_person_display_name_level_2]
					,trg.[employee_people_leader_employee_number_level_3]
					,trg.[employee_people_leader_email_level_3]
					,trg.[employee_people_leader_business_unit_name_level_3]
					,trg.[employee_people_leader_person_display_name_level_3]
					,trg.[employee_people_leader_employee_number_level_4]
					,trg.[employee_people_leader_email_level_4]
					,trg.[employee_people_leader_business_unit_name_level_4]
					,trg.[employee_people_leader_person_display_name_level_4]
					,trg.[employee_people_leader_employee_number_level_5]
					,trg.[employee_people_leader_email_level_5]
					,trg.[employee_people_leader_business_unit_name_level_5]
					,trg.[employee_people_leader_person_display_name_level_5]
					,trg.[employee_people_leader_employee_number_level_6]
					,trg.[employee_people_leader_email_level_6]
					,trg.[employee_people_leader_business_unit_name_level_6]
					,trg.[employee_people_leader_person_display_name_level_6]
					,trg.[employee_people_leader_employee_number_level_7]
					,trg.[employee_people_leader_email_level_7]
					,trg.[employee_people_leader_business_unit_name_level_7]
					,trg.[employee_people_leader_person_display_name_level_7]
					,trg.[employee_people_leader_employee_number_level_8]
					,trg.[employee_people_leader_email_level_8]
					,trg.[employee_people_leader_business_unit_name_level_8]
					,trg.[employee_people_leader_person_display_name_level_8]
					,trg.[employee_people_leader_employee_number_level_9]
					,trg.[employee_people_leader_email_level_9]
					,trg.[employee_people_leader_business_unit_name_level_9]
					,trg.[employee_people_leader_person_display_name_level_9]
					,trg.[employee_people_leader_role_name_level_1]
					,trg.[employee_people_leader_role_name_level_2]
					,trg.[employee_people_leader_role_name_level_3]
					,trg.[employee_people_leader_role_name_level_4]
					,trg.[employee_people_leader_role_name_level_5]
					,trg.[employee_people_leader_role_name_level_6]
					,trg.[employee_people_leader_role_name_level_7]
					,trg.[employee_people_leader_role_name_level_8]
					,trg.[employee_people_leader_role_name_level_9]
					,'X'
				)
			THEN
				UPDATE
				SET [DWHEffectiveTo] = @SystemEffectiveTo
					,[DWHIsCurrent] = 0 -- Soft delete missing records    
		WHEN NOT MATCHED BY source
			AND trg.[dim_employee_hierarchy_key] > 0
			AND trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo
			AND trg.[DWHDMLOperation] <> 'D'
			THEN
				UPDATE
				SET [DWHEffectiveTo] = @SystemEffectiveTo
					,[DWHIsCurrent] = 0 -- Insert new records   
		WHEN NOT MATCHED BY target
			THEN
				INSERT (
					[dim_employee_key]
					,[employee_id]
					,[employee_primary_email_address]
					,[employee_company_name]
					,[employee_Business_unit_name]
					,[employee_displayname]
					,[employee_people_leader_employee_number_level_1]
					,[employee_people_leader_email_level_1]
					,[employee_people_leader_business_unit_name_level_1]
					,[employee_people_leader_person_display_name_level_1]
					,[employee_people_leader_employee_number_level_2]
					,[employee_people_leader_email_level_2]
					,[employee_people_leader_business_unit_name_level_2]
					,[employee_people_leader_person_display_name_level_2]
					,[employee_people_leader_employee_number_level_3]
					,[employee_people_leader_email_level_3]
					,[employee_people_leader_business_unit_name_level_3]
					,[employee_people_leader_person_display_name_level_3]
					,[employee_people_leader_employee_number_level_4]
					,[employee_people_leader_email_level_4]
					,[employee_people_leader_business_unit_name_level_4]
					,[employee_people_leader_person_display_name_level_4]
					,[employee_people_leader_employee_number_level_5]
					,[employee_people_leader_email_level_5]
					,[employee_people_leader_business_unit_name_level_5]
					,[employee_people_leader_person_display_name_level_5]
					,[employee_people_leader_employee_number_level_6]
					,[employee_people_leader_email_level_6]
					,[employee_people_leader_business_unit_name_level_6]
					,[employee_people_leader_person_display_name_level_6]
					,[employee_people_leader_employee_number_level_7]
					,[employee_people_leader_email_level_7]
					,[employee_people_leader_business_unit_name_level_7]
					,[employee_people_leader_person_display_name_level_7]
					,[employee_people_leader_employee_number_level_8]
					,[employee_people_leader_email_level_8]
					,[employee_people_leader_business_unit_name_level_8]
					,[employee_people_leader_person_display_name_level_8]
					,[employee_people_leader_employee_number_level_9]
					,[employee_people_leader_email_level_9]
					,[employee_people_leader_business_unit_name_level_9]
					,[employee_people_leader_person_display_name_level_9]
					,[employee_people_leader_role_name_level_1]
					,[employee_people_leader_role_name_level_2]
					,[employee_people_leader_role_name_level_3]
					,[employee_people_leader_role_name_level_4]
					,[employee_people_leader_role_name_level_5]
					,[employee_people_leader_role_name_level_6]
					,[employee_people_leader_role_name_level_7]
					,[employee_people_leader_role_name_level_8]
					,[employee_people_leader_role_name_level_9]
					,[DWHSourceSystem]
					,[DWHBatchId]
					,[DWHDMLOperation]
					,[DWHEffectiveFrom]
					,[DWHEffectiveTo]
					,[DWHIsCurrent]
					)
				VALUES (
					src.[dim_employee_key]
					,src.[employee_id]
					,src.[employee_primary_email_address]
					,src.[employee_company_name]
					,src.[employee_Business_unit_name]
					,src.[employee_displayname]
					,src.[employee_people_leader_employee_number_level_1]
					,src.[employee_people_leader_email_level_1]
					,src.[employee_people_leader_business_unit_name_level_1]
					,src.[employee_people_leader_person_display_name_level_1]
					,src.[employee_people_leader_employee_number_level_2]
					,src.[employee_people_leader_email_level_2]
					,src.[employee_people_leader_business_unit_name_level_2]
					,src.[employee_people_leader_person_display_name_level_2]
					,src.[employee_people_leader_employee_number_level_3]
					,src.[employee_people_leader_email_level_3]
					,src.[employee_people_leader_business_unit_name_level_3]
					,src.[employee_people_leader_person_display_name_level_3]
					,src.[employee_people_leader_employee_number_level_4]
					,src.[employee_people_leader_email_level_4]
					,src.[employee_people_leader_business_unit_name_level_4]
					,src.[employee_people_leader_person_display_name_level_4]
					,src.[employee_people_leader_employee_number_level_5]
					,src.[employee_people_leader_email_level_5]
					,src.[employee_people_leader_business_unit_name_level_5]
					,src.[employee_people_leader_person_display_name_level_5]
					,src.[employee_people_leader_employee_number_level_6]
					,src.[employee_people_leader_email_level_6]
					,src.[employee_people_leader_business_unit_name_level_6]
					,src.[employee_people_leader_person_display_name_level_6]
					,src.[employee_people_leader_employee_number_level_7]
					,src.[employee_people_leader_email_level_7]
					,src.[employee_people_leader_business_unit_name_level_7]
					,src.[employee_people_leader_person_display_name_level_7]
					,src.[employee_people_leader_employee_number_level_8]
					,src.[employee_people_leader_email_level_8]
					,src.[employee_people_leader_business_unit_name_level_8]
					,src.[employee_people_leader_person_display_name_level_8]
					,src.[employee_people_leader_employee_number_level_9]
					,src.[employee_people_leader_email_level_9]
					,src.[employee_people_leader_business_unit_name_level_9]
					,src.[employee_people_leader_person_display_name_level_9]
					,src.[employee_people_leader_role_name_level_1]
					,src.[employee_people_leader_role_name_level_2]
					,src.[employee_people_leader_role_name_level_3]
					,src.[employee_people_leader_role_name_level_4]
					,src.[employee_people_leader_role_name_level_5]
					,src.[employee_people_leader_role_name_level_6]
					,src.[employee_people_leader_role_name_level_7]
					,src.[employee_people_leader_role_name_level_8]
					,src.[employee_people_leader_role_name_level_9]
					,src.[DWHSourceSystem]
					,src.[DWHBatchId]
					,src.[DWHDMLOperation]
					,src.[DWHEffectiveFrom]
					,src.[DWHEffectiveTo]
					,src.[DWHIsCurrent]
					)
		OUTPUT coalesce(src.[employee_id], inserted.[employee_id])
			,$ACTION AS [MergeAction]
		INTO #SummaryOfChanges;

		-- Insert new versions of previously updated records (Updates and Deletes)    
		INSERT INTO [edw].[dim_employee_hierarchy] (
			[dim_employee_key]
			,[employee_id]
			,[employee_primary_email_address]
			,[employee_company_name]
			,[employee_Business_unit_name]
			,[employee_displayname]
			,[employee_people_leader_employee_number_level_1]
			,[employee_people_leader_email_level_1]
			,[employee_people_leader_business_unit_name_level_1]
			,[employee_people_leader_person_display_name_level_1]
			,[employee_people_leader_employee_number_level_2]
			,[employee_people_leader_email_level_2]
			,[employee_people_leader_business_unit_name_level_2]
			,[employee_people_leader_person_display_name_level_2]
			,[employee_people_leader_employee_number_level_3]
			,[employee_people_leader_email_level_3]
			,[employee_people_leader_business_unit_name_level_3]
			,[employee_people_leader_person_display_name_level_3]
			,[employee_people_leader_employee_number_level_4]
			,[employee_people_leader_email_level_4]
			,[employee_people_leader_business_unit_name_level_4]
			,[employee_people_leader_person_display_name_level_4]
			,[employee_people_leader_employee_number_level_5]
			,[employee_people_leader_email_level_5]
			,[employee_people_leader_business_unit_name_level_5]
			,[employee_people_leader_person_display_name_level_5]
			,[employee_people_leader_employee_number_level_6]
			,[employee_people_leader_email_level_6]
			,[employee_people_leader_business_unit_name_level_6]
			,[employee_people_leader_person_display_name_level_6]
			,[employee_people_leader_employee_number_level_7]
			,[employee_people_leader_email_level_7]
			,[employee_people_leader_business_unit_name_level_7]
			,[employee_people_leader_person_display_name_level_7]
			,[employee_people_leader_employee_number_level_8]
			,[employee_people_leader_email_level_8]
			,[employee_people_leader_business_unit_name_level_8]
			,[employee_people_leader_person_display_name_level_8]
			,[employee_people_leader_employee_number_level_9]
			,[employee_people_leader_email_level_9]
			,[employee_people_leader_business_unit_name_level_9]
			,[employee_people_leader_person_display_name_level_9]
			,[employee_people_leader_role_name_level_1]
			,[employee_people_leader_role_name_level_2]
			,[employee_people_leader_role_name_level_3]
			,[employee_people_leader_role_name_level_4]
			,[employee_people_leader_role_name_level_5]
			,[employee_people_leader_role_name_level_6]
			,[employee_people_leader_role_name_level_7]
			,[employee_people_leader_role_name_level_8]
			,[employee_people_leader_role_name_level_9]
			,[DWHBatchId]
			,[DWHEffectiveFrom]
			,[DWHEffectiveTo]
			,[DWHIsCurrent]
			,[DWHSourceSystem]
			,[DWHDMLOperation]
			)
		SELECT src.[dim_employee_key]
			,src.[employee_id]
			,src.[employee_primary_email_address]
			,src.[employee_company_name]
			,src.[employee_Business_unit_name]
			,src.[employee_displayname]
			,src.[employee_people_leader_employee_number_level_1]
			,src.[employee_people_leader_email_level_1]
			,src.[employee_people_leader_business_unit_name_level_1]
			,src.[employee_people_leader_person_display_name_level_1]
			,src.[employee_people_leader_employee_number_level_2]
			,src.[employee_people_leader_email_level_2]
			,src.[employee_people_leader_business_unit_name_level_2]
			,src.[employee_people_leader_person_display_name_level_2]
			,src.[employee_people_leader_employee_number_level_3]
			,src.[employee_people_leader_email_level_3]
			,src.[employee_people_leader_business_unit_name_level_3]
			,src.[employee_people_leader_person_display_name_level_3]
			,src.[employee_people_leader_employee_number_level_4]
			,src.[employee_people_leader_email_level_4]
			,src.[employee_people_leader_business_unit_name_level_4]
			,src.[employee_people_leader_person_display_name_level_4]
			,src.[employee_people_leader_employee_number_level_5]
			,src.[employee_people_leader_email_level_5]
			,src.[employee_people_leader_business_unit_name_level_5]
			,src.[employee_people_leader_person_display_name_level_5]
			,src.[employee_people_leader_employee_number_level_6]
			,src.[employee_people_leader_email_level_6]
			,src.[employee_people_leader_business_unit_name_level_6]
			,src.[employee_people_leader_person_display_name_level_6]
			,src.[employee_people_leader_employee_number_level_7]
			,src.[employee_people_leader_email_level_7]
			,src.[employee_people_leader_business_unit_name_level_7]
			,src.[employee_people_leader_person_display_name_level_7]
			,src.[employee_people_leader_employee_number_level_8]
			,src.[employee_people_leader_email_level_8]
			,src.[employee_people_leader_business_unit_name_level_8]
			,src.[employee_people_leader_person_display_name_level_8]
			,src.[employee_people_leader_employee_number_level_9]
			,src.[employee_people_leader_email_level_9]
			,src.[employee_people_leader_business_unit_name_level_9]
			,src.[employee_people_leader_person_display_name_level_9]
			,src.[employee_people_leader_role_name_level_1]
			,src.[employee_people_leader_role_name_level_2]
			,src.[employee_people_leader_role_name_level_3]
			,src.[employee_people_leader_role_name_level_4]
			,src.[employee_people_leader_role_name_level_5]
			,src.[employee_people_leader_role_name_level_6]
			,src.[employee_people_leader_role_name_level_7]
			,src.[employee_people_leader_role_name_level_8]
			,src.[employee_people_leader_role_name_level_9]
			,@BatchID
			,@SystemEffectiveFrom
			,@SystemDefaultEffectiveTo
			,1
			,'[Staging].[ODSETLdim_employee_hierarchy]'
			,'U'
		FROM #SummaryOfChanges AS base
		INNER JOIN [Staging].[ODSETLdim_employee_hierarchy] AS src ON src.[employee_id] = base.[employee_id]
		WHERE base.[MergeAction] = 'UPDATE'
			AND base.[employee_id] <> 0
		
		UNION ALL
		
		SELECT tbl.[dim_employee_key]
			,tbl.[employee_id]
			,tbl.[employee_primary_email_address]
			,tbl.[employee_company_name]
			,tbl.[employee_Business_unit_name]
			,tbl.[employee_displayname]
			,tbl.[employee_people_leader_employee_number_level_1]
			,tbl.[employee_people_leader_email_level_1]
			,tbl.[employee_people_leader_business_unit_name_level_1]
			,tbl.[employee_people_leader_person_display_name_level_1]
			,tbl.[employee_people_leader_employee_number_level_2]
			,tbl.[employee_people_leader_email_level_2]
			,tbl.[employee_people_leader_business_unit_name_level_2]
			,tbl.[employee_people_leader_person_display_name_level_2]
			,tbl.[employee_people_leader_employee_number_level_3]
			,tbl.[employee_people_leader_email_level_3]
			,tbl.[employee_people_leader_business_unit_name_level_3]
			,tbl.[employee_people_leader_person_display_name_level_3]
			,tbl.[employee_people_leader_employee_number_level_4]
			,tbl.[employee_people_leader_email_level_4]
			,tbl.[employee_people_leader_business_unit_name_level_4]
			,tbl.[employee_people_leader_person_display_name_level_4]
			,tbl.[employee_people_leader_employee_number_level_5]
			,tbl.[employee_people_leader_email_level_5]
			,tbl.[employee_people_leader_business_unit_name_level_5]
			,tbl.[employee_people_leader_person_display_name_level_5]
			,tbl.[employee_people_leader_employee_number_level_6]
			,tbl.[employee_people_leader_email_level_6]
			,tbl.[employee_people_leader_business_unit_name_level_6]
			,tbl.[employee_people_leader_person_display_name_level_6]
			,tbl.[employee_people_leader_employee_number_level_7]
			,tbl.[employee_people_leader_email_level_7]
			,tbl.[employee_people_leader_business_unit_name_level_7]
			,tbl.[employee_people_leader_person_display_name_level_7]
			,tbl.[employee_people_leader_employee_number_level_8]
			,tbl.[employee_people_leader_email_level_8]
			,tbl.[employee_people_leader_business_unit_name_level_8]
			,tbl.[employee_people_leader_person_display_name_level_8]
			,tbl.[employee_people_leader_employee_number_level_9]
			,tbl.[employee_people_leader_email_level_9]
			,tbl.[employee_people_leader_business_unit_name_level_9]
			,tbl.[employee_people_leader_person_display_name_level_9]
			,tbl.[employee_people_leader_role_name_level_1]
			,tbl.[employee_people_leader_role_name_level_2]
			,tbl.[employee_people_leader_role_name_level_3]
			,tbl.[employee_people_leader_role_name_level_4]
			,tbl.[employee_people_leader_role_name_level_5]
			,tbl.[employee_people_leader_role_name_level_6]
			,tbl.[employee_people_leader_role_name_level_7]
			,tbl.[employee_people_leader_role_name_level_8]
			,tbl.[employee_people_leader_role_name_level_9]
			,@BatchID
			,@SystemEffectiveFrom
			,@SystemDefaultEffectiveTo
			,1
			,'[Staging].[ODSETLdim_employee_hierarchy]'
			,'D'
		FROM #SummaryOfChanges AS base
		INNER JOIN [edw].[dim_employee_hierarchy] AS tbl ON tbl.[employee_id] = base.[employee_id]
			AND tbl.[DWHEffectiveTo] = @SystemEffectiveTo
		LEFT JOIN [Staging].[ODSETLdim_employee_hierarchy] AS src ON src.[employee_id] = base.[employee_id]
		WHERE base.[MergeAction] = 'UPDATE'
			AND base.[employee_id] <> 0
			AND src.[employee_id] IS NULL;
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
		FROM [edw].[dim_employee_hierarchy]
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