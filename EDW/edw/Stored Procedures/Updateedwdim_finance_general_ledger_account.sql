/**********************************************************************************************************
Procedure	[edw].[Updateedwdim_finance_general_ledger_account] 
Author		Manish Singh
Created		2023/05/01
Purpose		Load GL account data ,create account Hirerachy 
				

				
Notes: Call By	EDW Pipeline '30_Load_From_ODS'
Parameter(s)  None 
=========================================================================================================
REVISIONS:
Version	 Date		   Author			Description
-------	------------  ---------------	--------------------------
1.0		2023-01-23    Manish Singh		Initial version
1.1		2023-07-04    Manish Singh		Changed incoroprated due to change in Table colum Name for i.e company_code to finance_general_ledger_account_company_name
1.2		2023-08-04    Glenn Mcleod		Updated to use table Framework table names.
										Updated 0 record insert script.
1.21	2023-08-21	  Glenn McLeod		Rename source tables
1.22	2023-08-23	  Glenn McLeod		Altered to stop 0 record [DWHEffectiveTo] from being update
1.23	2023-08-25	  Glenn McLeod		Updated table/column names
1.3		2023-09-25	  Glenn McLeod		Add -1 record of for Unknown and updated 0 record to be N/A
2.0		2025-04-01	  Greg Nuthall		Changed to ensure the updated records get inserted (removed begin and commit) 
										and changed the source system
2.1		2025-09-11    Greg Nuthall		Bug 11244: Changed @pOutputParamsAsDataset default from 0 to 1 to show records processed
2.2		2025-11-17    Malhar Badheka	User Story 11508: Added Subcategory_Entry_No and Subcategory_Description fields

**********************************************************************************************************/

CREATE procedure [edw].[Updateedwdim_finance_general_ledger_account] 
	@pBatchID int, 
	@pIndexRebuildThreshold int,
	@pOutputParamsAsDataset int = 1,
	@pErrorRecords int = null OUTPUT, 
	@pInsertRecords int = null OUTPUT, 
	@pUpdateRecords int = null OUTPUT, 
	@pDeleteRecords int = null OUTPUT,
	@pCompleted int = null OUTPUT,
	@pTargetRecords int = null OUTPUT,
	@pErrorMessage varchar(MAX) = null OUTPUT
as 

begin

	set nocount on;
	set xact_abort on;

	-- Variables
	declare @batchID int = @pBatchID;
	declare @SourceSystem nvarchar(120) = 'BusinessCentral.glAccounts';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	declare @SystemEffectiveFrom datetime = @systemCurrentDate;
	declare @SystemEffectiveTo datetime = dateadd(second,-1,@SystemEffectiveFrom);
	declare @SystemDefaultEffectiveFrom datetime = convert(DATETIME,'1 January 1900');
	declare @SystemDefaultEffectiveTo datetime = convert(DATETIME, '31 December 2999 23:59:59');

	--begin transaction;
	--commit transaction;

	begin try

	IF NOT EXISTS (
		SELECT dim_finance_general_ledger_account_key
		FROM [edw].[dim_finance_general_ledger_account] where [dim_finance_general_ledger_account_key] <= 0
		)
	BEGIN
		-- turn the identity insert on 
		SET IDENTITY_INSERT [edw].[dim_finance_general_ledger_account] ON

		INSERT INTO [edw].[dim_finance_general_ledger_account] (
			dim_finance_general_ledger_account_key
			,finance_general_ledger_account_company_name
			,finance_general_ledger_account_code
			,finance_general_ledger_account_description
			,finance_general_ledger_account_report_sort_order
			,finance_general_ledger_account_type
			,finance_general_ledger_account_type_description
			,finance_general_ledger_account_category
			,finance_general_ledger_account_category_description
			,finance_general_ledger_account_direct_posting_flag
			,finance_general_ledger_account_hierarchy_first_level_code
			,finance_general_ledger_account_hierarchy_first_level_name
			,finance_general_ledger_account_hierarchy_structure
			,finance_general_ledger_account_hierarchy_length_depth
			,finance_general_ledger_account_parent_code
			,finance_general_ledger_account_hierarchy_second_level_code
			,finance_general_ledger_account_hierarchy_second_level_name
			,finance_general_ledger_account_hierarchy_third_level_code
			,finance_general_ledger_account_hierarchy_third_level_name
			,finance_general_ledger_account_hierarchy_fourth_level_code
			,finance_general_ledger_account_hierarchy_fourth_level_name
			,finance_general_ledger_account_hierarchy_fifth_level_code
			,finance_general_ledger_account_hierarchy_fifth_level_name
			,finance_general_ledger_account_hierarchy_sixth_level_code
			,finance_general_ledger_account_hierarchy_sixth_level_name
			,finance_general_ledger_account_subcategory_entry_no
			,finance_general_ledger_account_subcategory_description
			,[DWHSourceSystem]
			,[DWHBatchId]
			,[DWHDMLOperation]
			,[DWHEffectiveFrom]
			,[DWHEffectiveTo]
			,[DWHIsCurrent]

			)
		VALUES (
				0
				,'N/A'
				,0
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,0
				,'N/A'
				,'N/A'
				,'n/a'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,0
				,'N/A'
			,'BusinessCentral.glAccounts'
			,0
			,'I'
			,@SystemDefaultEffectiveFrom
			,@SystemDefaultEffectiveTo
			,1
			),
			(
			-1
			,'Unknown'
			,-1
			,'Unknown'
			,'Unknown'
			,'Unknown'
			,'Unknown'
			,-1
			,'Unknown'
			,'Unknown'
			,'Unk'
			,'Unknown'
			,'Unknown'
			,'Unknown'
			,'Unknown'
			,'Unknown'
			,'Unknown'
			,'Unknown'
			,'Unknown'
			,'Unknown'
			,'Unknown'
			,'Unknown'
			,'Unknown'
			,'Unknown'
			,'Unknown'
			,-1
			,'Unknown'
			,'BusinessCentral.glAccounts'
			,0
			,'I'
			,@SystemDefaultEffectiveFrom
			,@SystemDefaultEffectiveTo
			,1
			)
			-- turn the identity insert off
			SET IDENTITY_INSERT [edw].[dim_finance_general_ledger_account] OFF
	END


	-- Do not run if there are records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLdim_finance_general_ledger_account];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) 
			,@deletedRecords = sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			from [edw].[dim_finance_general_ledger_account];

		-- Select success details
		select
			 @pErrorRecords = 0
			,@pInsertRecords = 0
			,@pUpdateRecords = 0
			,@pDeleteRecords = 0
			,@pCompleted = 1
			,@pTargetRecords = @targetRecords
	

		if (@pOutputParamsAsDataset = 1)
		begin
			-- Select return parameters as a dataset
			select @pErrorRecords	as ErrorRecords,
					@pInsertRecords as InsertRecords,
					@pUpdateRecords as UpdateRecords,
					@pDeleteRecords as DeleteRecords,
					@pCompleted		as Completed,
					@targetRecords	as TargetRecords,
					@pErrorMessage as ErrorMessage;	
			end;

		return;
	end;



	if( object_id( 'tempdb..#SummaryOfChanges') is not null ) drop table #SummaryOfChanges;
	create table #SummaryOfChanges
	(	
		 [finance_general_ledger_account_code] nvarchar(104) null
		,[finance_general_ledger_account_company_name] nvarchar(129) null
		,[MergeAction] varchar(10)
	);

	if( not exists (select top(1) 1 from [edw].[dim_finance_general_ledger_account] where dim_finance_general_ledger_account_key >0) )
		begin
			-- There are no records in the target; insert all
			INSERT INTO [edw].[dim_finance_general_ledger_account] (
				[finance_general_ledger_account_company_name]
				,[finance_general_ledger_account_code]
				,[finance_general_ledger_account_description]
				,[finance_general_ledger_account_report_sort_order]
				,[finance_general_ledger_account_type]
				,[finance_general_ledger_account_type_description]
				,[finance_general_ledger_account_category]
				,[finance_general_ledger_account_category_description]
				,[finance_general_ledger_account_direct_posting_flag]
				,[finance_general_ledger_account_hierarchy_first_level_code]
				,[finance_general_ledger_account_hierarchy_first_level_name]
				,[finance_general_ledger_account_hierarchy_structure]
				,[finance_general_ledger_account_hierarchy_length_depth]
				,[finance_general_ledger_account_parent_code]
				,[finance_general_ledger_account_hierarchy_second_level_code]
				,[finance_general_ledger_account_hierarchy_second_level_name]
				,[finance_general_ledger_account_hierarchy_third_level_code]
				,[finance_general_ledger_account_hierarchy_third_level_name]
				,[finance_general_ledger_account_hierarchy_fourth_level_code]
				,[finance_general_ledger_account_hierarchy_fourth_level_name]
				,[finance_general_ledger_account_hierarchy_fifth_level_code]
				,[finance_general_ledger_account_hierarchy_fifth_level_name]
				,[finance_general_ledger_account_hierarchy_sixth_level_code]
				,[finance_general_ledger_account_hierarchy_sixth_level_name]
				,[finance_general_ledger_account_subcategory_entry_no]
				,[finance_general_ledger_account_subcategory_description]
				,[DWHSourceSystem]
				,[DWHBatchId]
				,[DWHDMLOperation]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				)
			SELECT src.finance_general_ledger_account_company_name
				,src.finance_general_ledger_account_code
				,src.finance_general_ledger_account_description
				,src.finance_general_ledger_account_report_sort_order
				,src.finance_general_ledger_account_type
				,src.finance_general_ledger_account_type_description
				,src.finance_general_ledger_account_category
				,src.finance_general_ledger_account_category_description
				,src.finance_general_ledger_account_direct_posting_flag
				,src.finance_general_ledger_account_hierarchy_first_level_code
				,src.finance_general_ledger_account_hierarchy_first_level_name
				,src.finance_general_ledger_account_hierarchy_structure
				,src.finance_general_ledger_account_hierarchy_length_depth
				,src.finance_general_ledger_account_parent_code
				,src.finance_general_ledger_account_hierarchy_second_level_code
				,src.finance_general_ledger_account_hierarchy_second_level_name
				,src.finance_general_ledger_account_hierarchy_third_level_code
				,src.finance_general_ledger_account_hierarchy_third_level_name
				,src.finance_general_ledger_account_hierarchy_fourth_level_code
				,src.finance_general_ledger_account_hierarchy_fourth_level_name
				,src.finance_general_ledger_account_hierarchy_fifth_level_code
				,src.finance_general_ledger_account_hierarchy_fifth_level_name
				,src.finance_general_ledger_account_hierarchy_sixth_level_code
				,src.finance_general_ledger_account_hierarchy_sixth_level_name
				,src.finance_general_ledger_account_subcategory_entry_no
				,src.finance_general_ledger_account_subcategory_description
				,@SourceSystem AS [DWHSourceSystem]
				,@BatchID AS [DWHBatchId]
				,'I' AS [DWHDMLOperation]
				,convert(DATETIME, '1 January 1900') AS [DWHEffectiveFrom]
				,convert(DATETIME, '31 December 2999 23:59:59') AS [DWHEffectiveTo]
				,1 AS [DWHIsCurrent]
			FROM [Staging].[ODSETLdim_finance_general_ledger_account] AS src;

		end 
		
		else begin
			
			MERGE INTO [edw].[dim_finance_general_ledger_account] AS trg
			USING (
				SELECT src.finance_general_ledger_account_company_name
					,src.finance_general_ledger_account_code
					,src.finance_general_ledger_account_description
					,src.finance_general_ledger_account_report_sort_order
					,src.finance_general_ledger_account_type
					,src.finance_general_ledger_account_type_description
					,src.finance_general_ledger_account_category
					,src.finance_general_ledger_account_category_description
					,src.finance_general_ledger_account_direct_posting_flag
					,src.finance_general_ledger_account_hierarchy_first_level_code
					,src.finance_general_ledger_account_hierarchy_first_level_name
					,src.finance_general_ledger_account_hierarchy_structure
					,src.finance_general_ledger_account_hierarchy_length_depth
					,src.finance_general_ledger_account_parent_code
					,src.finance_general_ledger_account_hierarchy_second_level_code
					,src.finance_general_ledger_account_hierarchy_second_level_name
					,src.finance_general_ledger_account_hierarchy_third_level_code
					,src.finance_general_ledger_account_hierarchy_third_level_name
					,src.finance_general_ledger_account_hierarchy_fourth_level_code
					,src.finance_general_ledger_account_hierarchy_fourth_level_name
					,src.finance_general_ledger_account_hierarchy_fifth_level_code
					,src.finance_general_ledger_account_hierarchy_fifth_level_name
					,src.finance_general_ledger_account_hierarchy_sixth_level_code
					,src.finance_general_ledger_account_hierarchy_sixth_level_name
					,src.finance_general_ledger_account_subcategory_entry_no
					,src.finance_general_ledger_account_subcategory_description
					,@SourceSystem AS [DWHSourceSystem]
					,@BatchID AS [DWHBatchId]
					,'I' AS [DWHDMLOperation]
					,convert(DATETIME, '1 January 1900') AS [DWHEffectiveFrom]
					,convert(DATETIME, '31 December 2999 23:59:59') AS [DWHEffectiveTo]
					,1 AS [DWHIsCurrent]
				FROM [Staging].[ODSETLdim_finance_general_ledger_account] AS src
				) AS src
				ON (
						src.[finance_general_ledger_account_company_name] = trg.[finance_general_ledger_account_company_name]
						AND src.[finance_general_ledger_account_code] = trg.[finance_general_ledger_account_code]
						AND trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo
						) -- Retire existing records
			WHEN MATCHED
				AND EXISTS (
					SELECT src.finance_general_ledger_account_company_name
						,src.finance_general_ledger_account_code
						,src.finance_general_ledger_account_description
						,src.finance_general_ledger_account_report_sort_order
						,src.finance_general_ledger_account_type
						,src.finance_general_ledger_account_type_description
						,src.finance_general_ledger_account_category
						,src.finance_general_ledger_account_category_description
						,src.finance_general_ledger_account_direct_posting_flag
						,src.finance_general_ledger_account_hierarchy_first_level_code
						,src.finance_general_ledger_account_hierarchy_first_level_name
						,src.finance_general_ledger_account_hierarchy_structure
						,src.finance_general_ledger_account_hierarchy_length_depth
						,src.finance_general_ledger_account_parent_code
						,src.finance_general_ledger_account_hierarchy_second_level_code
						,src.finance_general_ledger_account_hierarchy_second_level_name
						,src.finance_general_ledger_account_hierarchy_third_level_code
						,src.finance_general_ledger_account_hierarchy_third_level_name
						,src.finance_general_ledger_account_hierarchy_fourth_level_code
						,src.finance_general_ledger_account_hierarchy_fourth_level_name
						,src.finance_general_ledger_account_hierarchy_fifth_level_code
						,src.finance_general_ledger_account_hierarchy_fifth_level_name
						,src.finance_general_ledger_account_hierarchy_sixth_level_code
						,src.finance_general_ledger_account_hierarchy_sixth_level_name
						,src.finance_general_ledger_account_subcategory_entry_no
						,src.finance_general_ledger_account_subcategory_description
						,CASE 
							WHEN trg.[DWHDMLOperation] = 'D'
								THEN 'U'
							ELSE 'X'
							END
		
					EXCEPT
		
					SELECT trg.finance_general_ledger_account_company_name
						,trg.finance_general_ledger_account_code
						,trg.finance_general_ledger_account_description
						,trg.finance_general_ledger_account_report_sort_order
						,trg.finance_general_ledger_account_type
						,trg.finance_general_ledger_account_type_description
						,trg.finance_general_ledger_account_category
						,trg.finance_general_ledger_account_category_description
						,trg.finance_general_ledger_account_direct_posting_flag
						,trg.finance_general_ledger_account_hierarchy_first_level_code
						,trg.finance_general_ledger_account_hierarchy_first_level_name
						,trg.finance_general_ledger_account_hierarchy_structure
						,trg.finance_general_ledger_account_hierarchy_length_depth
						,trg.finance_general_ledger_account_parent_code
						,trg.finance_general_ledger_account_hierarchy_second_level_code
						,trg.finance_general_ledger_account_hierarchy_second_level_name
						,trg.finance_general_ledger_account_hierarchy_third_level_code
						,trg.finance_general_ledger_account_hierarchy_third_level_name
						,trg.finance_general_ledger_account_hierarchy_fourth_level_code
						,trg.finance_general_ledger_account_hierarchy_fourth_level_name
						,trg.finance_general_ledger_account_hierarchy_fifth_level_code
						,trg.finance_general_ledger_account_hierarchy_fifth_level_name
						,trg.finance_general_ledger_account_hierarchy_sixth_level_code
						,trg.finance_general_ledger_account_hierarchy_sixth_level_name
						,trg.finance_general_ledger_account_subcategory_entry_no
						,trg.finance_general_ledger_account_subcategory_description
						,'X'
					)
				THEN
					UPDATE
					SET [DWHEffectiveTo] = @SystemEffectiveTo
						,[DWHIsCurrent] = 0 -- Soft delete missing records
						,[DWHSourceSystem] = 'BusinessCentral.glAccounts'
			WHEN NOT MATCHED BY source
				AND trg.[dim_finance_general_ledger_account_key] > 0
				AND trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo
				AND trg.[DWHDMLOperation] <> 'D'
				THEN
					UPDATE
					SET [DWHEffectiveTo] = @SystemEffectiveTo
						,[DWHIsCurrent] = 0 -- Insert new records
						,[DWHSourceSystem] = 'BusinessCentral.glAccounts'
			WHEN NOT MATCHED BY target
				THEN
					INSERT (
						finance_general_ledger_account_company_name
						,finance_general_ledger_account_code
						,finance_general_ledger_account_description
						,finance_general_ledger_account_report_sort_order
						,finance_general_ledger_account_type
						,finance_general_ledger_account_type_description
						,finance_general_ledger_account_category
						,finance_general_ledger_account_category_description
						,finance_general_ledger_account_direct_posting_flag
						,finance_general_ledger_account_hierarchy_first_level_code
						,finance_general_ledger_account_hierarchy_first_level_name
						,finance_general_ledger_account_hierarchy_structure
						,finance_general_ledger_account_hierarchy_length_depth
						,finance_general_ledger_account_parent_code
						,finance_general_ledger_account_hierarchy_second_level_code
						,finance_general_ledger_account_hierarchy_second_level_name
						,finance_general_ledger_account_hierarchy_third_level_code
						,finance_general_ledger_account_hierarchy_third_level_name
						,finance_general_ledger_account_hierarchy_fourth_level_code
						,finance_general_ledger_account_hierarchy_fourth_level_name
						,finance_general_ledger_account_hierarchy_fifth_level_code
						,finance_general_ledger_account_hierarchy_fifth_level_name
						,finance_general_ledger_account_hierarchy_sixth_level_code
						,finance_general_ledger_account_hierarchy_sixth_level_name
						,finance_general_ledger_account_subcategory_entry_no
						,finance_general_ledger_account_subcategory_description
						,[DWHSourceSystem]
						,[DWHBatchId]
						,[DWHDMLOperation]
						,[DWHEffectiveFrom]
						,[DWHEffectiveTo]
						,[DWHIsCurrent]
						)
					VALUES (
						src.finance_general_ledger_account_company_name
						,src.finance_general_ledger_account_code
						,src.finance_general_ledger_account_description
						,src.finance_general_ledger_account_report_sort_order
						,src.finance_general_ledger_account_type
						,src.finance_general_ledger_account_type_description
						,src.finance_general_ledger_account_category
						,src.finance_general_ledger_account_category_description
						,src.finance_general_ledger_account_direct_posting_flag
						,src.finance_general_ledger_account_hierarchy_first_level_code
						,src.finance_general_ledger_account_hierarchy_first_level_name
						,src.finance_general_ledger_account_hierarchy_structure
						,src.finance_general_ledger_account_hierarchy_length_depth
						,src.finance_general_ledger_account_parent_code
						,src.finance_general_ledger_account_hierarchy_second_level_code
						,src.finance_general_ledger_account_hierarchy_second_level_name
						,src.finance_general_ledger_account_hierarchy_third_level_code
						,src.finance_general_ledger_account_hierarchy_third_level_name
						,src.finance_general_ledger_account_hierarchy_fourth_level_code
						,src.finance_general_ledger_account_hierarchy_fourth_level_name
						,src.finance_general_ledger_account_hierarchy_fifth_level_code
						,src.finance_general_ledger_account_hierarchy_fifth_level_name
						,src.finance_general_ledger_account_hierarchy_sixth_level_code
						,src.finance_general_ledger_account_hierarchy_sixth_level_name
						,src.finance_general_ledger_account_subcategory_entry_no
						,src.finance_general_ledger_account_subcategory_description
						,'BusinessCentral.glAccounts'
						,src.[DWHBatchId]
						,src.[DWHDMLOperation]
						,src.[DWHEffectiveFrom]
						,src.[DWHEffectiveTo]
						,src.[DWHIsCurrent]
						)
			OUTPUT coalesce(src.[finance_general_ledger_account_company_name], inserted.[finance_general_ledger_account_company_name])
				,coalesce(src.[finance_general_ledger_account_code], inserted.[finance_general_ledger_account_code])
				,$ACTION AS [MergeAction]
			INTO #SummaryOfChanges;

			-- Insert new versions of previously updated records (Updates and Deletes)    
			INSERT INTO [edw].[dim_finance_general_ledger_account] (
				finance_general_ledger_account_company_name
				,finance_general_ledger_account_code
				,finance_general_ledger_account_description
				,finance_general_ledger_account_report_sort_order
				,finance_general_ledger_account_type
				,finance_general_ledger_account_type_description
				,finance_general_ledger_account_category
				,finance_general_ledger_account_category_description
				,finance_general_ledger_account_direct_posting_flag
				,finance_general_ledger_account_hierarchy_first_level_code
				,finance_general_ledger_account_hierarchy_first_level_name
				,finance_general_ledger_account_hierarchy_structure
				,finance_general_ledger_account_hierarchy_length_depth
				,finance_general_ledger_account_parent_code
				,finance_general_ledger_account_hierarchy_second_level_code
				,finance_general_ledger_account_hierarchy_second_level_name
				,finance_general_ledger_account_hierarchy_third_level_code
				,finance_general_ledger_account_hierarchy_third_level_name
				,finance_general_ledger_account_hierarchy_fourth_level_code
				,finance_general_ledger_account_hierarchy_fourth_level_name
				,finance_general_ledger_account_hierarchy_fifth_level_code
				,finance_general_ledger_account_hierarchy_fifth_level_name
				,finance_general_ledger_account_hierarchy_sixth_level_code
				,finance_general_ledger_account_hierarchy_sixth_level_name
				,finance_general_ledger_account_subcategory_entry_no
				,finance_general_ledger_account_subcategory_description
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
				)
			SELECT src.finance_general_ledger_account_company_name
				,src.finance_general_ledger_account_code
				,src.finance_general_ledger_account_description
				,src.finance_general_ledger_account_report_sort_order
				,src.finance_general_ledger_account_type
				,src.finance_general_ledger_account_type_description
				,src.finance_general_ledger_account_category
				,src.finance_general_ledger_account_category_description
				,src.finance_general_ledger_account_direct_posting_flag
				,src.finance_general_ledger_account_hierarchy_first_level_code
				,src.finance_general_ledger_account_hierarchy_first_level_name
				,src.finance_general_ledger_account_hierarchy_structure
				,src.finance_general_ledger_account_hierarchy_length_depth
				,src.finance_general_ledger_account_parent_code
				,src.finance_general_ledger_account_hierarchy_second_level_code
				,src.finance_general_ledger_account_hierarchy_second_level_name
				,src.finance_general_ledger_account_hierarchy_third_level_code
				,src.finance_general_ledger_account_hierarchy_third_level_name
				,src.finance_general_ledger_account_hierarchy_fourth_level_code
				,src.finance_general_ledger_account_hierarchy_fourth_level_name
				,src.finance_general_ledger_account_hierarchy_fifth_level_code
				,src.finance_general_ledger_account_hierarchy_fifth_level_name
				,src.finance_general_ledger_account_hierarchy_sixth_level_code
				,src.finance_general_ledger_account_hierarchy_sixth_level_name
				,src.finance_general_ledger_account_subcategory_entry_no
				,src.finance_general_ledger_account_subcategory_description
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'BusinessCentral.glAccounts'
				,'U'
			FROM #SummaryOfChanges AS base
			INNER JOIN [Staging].[ODSETLdim_finance_general_ledger_account] AS src ON src.[finance_general_ledger_account_company_name] = base.[finance_general_ledger_account_company_name]
				AND src.[finance_general_ledger_account_code] = base.[finance_general_ledger_account_code]
			WHERE base.[MergeAction] = 'UPDATE'
				AND base.[finance_general_ledger_account_company_name] <> 'Unknown'
				AND base.[finance_general_ledger_account_code] <> '0'

			UNION ALL

			SELECT tbl.finance_general_ledger_account_company_name
				,tbl.finance_general_ledger_account_code
				,tbl.finance_general_ledger_account_description
				,tbl.finance_general_ledger_account_report_sort_order
				,tbl.finance_general_ledger_account_type
				,tbl.finance_general_ledger_account_type_description
				,tbl.finance_general_ledger_account_category
				,tbl.finance_general_ledger_account_category_description
				,tbl.finance_general_ledger_account_direct_posting_flag
				,tbl.finance_general_ledger_account_hierarchy_first_level_code
				,tbl.finance_general_ledger_account_hierarchy_first_level_name
				,tbl.finance_general_ledger_account_hierarchy_structure
				,tbl.finance_general_ledger_account_hierarchy_length_depth
				,tbl.finance_general_ledger_account_parent_code
				,tbl.finance_general_ledger_account_hierarchy_second_level_code
				,tbl.finance_general_ledger_account_hierarchy_second_level_name
				,tbl.finance_general_ledger_account_hierarchy_third_level_code
				,tbl.finance_general_ledger_account_hierarchy_third_level_name
				,tbl.finance_general_ledger_account_hierarchy_fourth_level_code
				,tbl.finance_general_ledger_account_hierarchy_fourth_level_name
				,tbl.finance_general_ledger_account_hierarchy_fifth_level_code
				,tbl.finance_general_ledger_account_hierarchy_fifth_level_name
				,tbl.finance_general_ledger_account_hierarchy_sixth_level_code
				,tbl.finance_general_ledger_account_hierarchy_sixth_level_name
				,tbl.finance_general_ledger_account_subcategory_entry_no
				,tbl.finance_general_ledger_account_subcategory_description
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'deletes '
				,'D'
			FROM #SummaryOfChanges AS base
			INNER JOIN [edw].[dim_finance_general_ledger_account] AS tbl ON tbl.[finance_general_ledger_account_company_name] = base.[finance_general_ledger_account_company_name]
				AND tbl.[finance_general_ledger_account_code] = base.[finance_general_ledger_account_code]
				AND tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			LEFT JOIN [Staging].[ODSETLdim_finance_general_ledger_account] AS src ON src.[finance_general_ledger_account_company_name] = base.[finance_general_ledger_account_company_name]
				AND src.[finance_general_ledger_account_code] = base.[finance_general_ledger_account_code]
			WHERE base.[MergeAction] = 'UPDATE'
				AND base.[finance_general_ledger_account_company_name] <> 'Unknown'
				AND base.[finance_general_ledger_account_code] <> '0'
				AND src.[finance_general_ledger_account_company_name] IS NULL
				AND src.finance_general_ledger_account_code IS NULL;


		end;

		select * from #SummaryOfChanges;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[dim_finance_general_ledger_account]
		where [DWHEffectiveTo] = @SystemDefaultEffectiveTo;

		
	end try
	begin catch
		rollback transaction;

		set @pErrorRecords = @stagedRecords - @insertedRecords - @updatedRecords - @deletedRecords;
		set @pInsertRecords = @insertedRecords;
		set @pUpdateRecords = @updatedRecords;
		set @pDeleteRecords = @deletedRecords;
		set @pCompleted = 0;
		set @pTargetRecords = @targetRecords;
		set @pErrorMessage = ERROR_MESSAGE();

		if (@pOutputParamsAsDataset = 1)
		begin
			-- Select return parameters as a dataset
			select @pErrorRecords	as ErrorRecords,
					@pInsertRecords as InsertRecords,
					@pUpdateRecords as UpdateRecords,
					@pDeleteRecords as DeleteRecords,
					@pCompleted		as Completed,
					@targetRecords	as TargetRecords,
					@pErrorMessage as ErrorMessage;
		end;
		throw;
	end catch

	set @pErrorRecords = @stagedRecords - @insertedRecords - @updatedRecords - @deletedRecords;
	set @pInsertRecords = @insertedRecords;
	set @pUpdateRecords = @updatedRecords;
	set @pDeleteRecords = @deletedRecords;
	set @pCompleted = 1;
	set @pTargetRecords = @targetRecords;

	if (@pOutputParamsAsDataset = 1)
	begin
		-- Select return parameters as a dataset
		select @pErrorRecords	as ErrorRecords,
				@pInsertRecords as InsertRecords,
				@pUpdateRecords as UpdateRecords,
				@pDeleteRecords as DeleteRecords,
				@pCompleted		as Completed,
				@targetRecords	as TargetRecords,
				@pErrorMessage as ErrorMessage;
	end;
end;