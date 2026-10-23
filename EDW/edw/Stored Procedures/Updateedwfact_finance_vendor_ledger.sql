









/***************************************************************************
NAME:     [edw].[Updateedwfact_finance_vendor_ledger] 
PURPOSE:  Move data from landing.fact_finance_vendor_ledger table into
				[staging].[ODSETLfact_finance_vendor_ledger]
				

 Notes: Call By	EDW Pipeline '30_Load_From_ODS'

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2023-06-26    Shashi Sharma			Initial creation of stored procedure
1.1		2023-08-30	  Glenn McLeod			Updated to use table Framework table names 
1.2		2023-09-25	  Glenn McLeod			Update to identify difference between N/A and Unknown dim records
1.3		2026-04-28    Pankaj Bhatt			Update join for location dim

****************************************************************************/


CREATE procedure [edw].[Updateedwfact_finance_vendor_ledger] 
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
as begin

	set nocount on;
	set xact_abort on;

	-- Variables
	declare @batchID int = @pBatchID;
	declare @SourceSystem nvarchar(120) = '[Staging].[ODSETLfact_finance_vendor_ledger]';

	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	declare @SystemEffectiveFrom datetime = @systemCurrentDate;
	declare @SystemEffectiveTo datetime = dateadd(second,-1,@SystemEffectiveFrom);
	declare @SystemDefaultEffectiveFrom datetime = '1 January 1900';
	declare @SystemDefaultEffectiveTo datetime = '31 December 2999 23:59:59';
	if( object_id( 'tempdb..#SummaryOfChanges') is not null ) drop table #SummaryOfChanges;
	create table #SummaryOfChanges
	(	
			 [PartitionKey] nvarchar(129) null
		,[RowKey] nvarchar(107) null
		,[MergeAction] varchar(10)
	);
	begin transaction;
	begin try
		
		-- Do not run if there are no records in source
		select @stagedRecords = count(1) from [Staging].[ODSETLfact_finance_vendor_ledger];
		if( @stagedRecords = 0 )
		begin
			select 
				 @targetRecords = count(1) 
				,@deletedRecords = sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			from [edw].[fact_finance_vendor_ledger];
			-- Select success details
			select
				 @pErrorRecords = 0
				,@pInsertRecords = 0
				,@pUpdateRecords = 0
				,@pDeleteRecords = 0
				,@pCompleted = 1
				,@pTargetRecords = @targetRecords;	

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

			commit transaction;
			return;
		end;



		 -- Deal with Slowly Changing Diminision Type 1 columns here
		WITH TARGET
		AS (SELECT 
			 [dim_finance_general_ledger_account_key]
			,[dim_finance_budget_holder_key]
			,[dim_finance_contract_key]
			,[dim_department_key]
			,[dim_district_key]
			,[dim_finance_funder_key]
			,[dim_finance_funding_agency_key]
			,[dim_location_key]
			,[dim_region_key]
			,[dim_service_key]
			,[dim_finance_vendor_key]
			,[dim_company_key]
			,[fact_finance_vendor_ledger_partition_key]
			,[fact_finance_vendor_ledger_row_key]
			,[finance_budget_holder_id]
			,[finance_contract_id]
			,[department_id]
			,[district_id]
			,[finance_funder_id]
			,[finance_funding_agency_id]
			,[location_id]
			,[region_id]
			,[service_id]
			,[finance_vendor_id]
			,[user_id]
			,[finance_vendor_ledger_dimension_set_id]
			,[finance_vendor_ledger_company_name]
			,[finance_vendor_ledger_bal_account_no]
			,[finance_vendor_ledger_bal_account_type]
			,[finance_vendor_ledger_vendor_no]
			,[finance_vendor_ledger_vendor_name]
			,[finance_vendor_ledger_buy_from_vendor_no]
			,[finance_vendor_ledger_global_dimension_1_code]
			,[finance_vendor_ledger_no_series]
			,[finance_vendor_ledger_open]
			,[finance_vendor_ledger_closed_by_entry_no]
			,[finance_vendor_ledger_document_no]
			,[finance_vendor_ledger_document_type]
			,[finance_vendor_ledger_external_document_no]
			,[finance_vendor_ledger_description]
			,[finance_vendor_ledger_payment_method_code]
			,[finance_vendor_ledger_source_code]
			,[finance_document_date_key]
			,[finance_due_date_key]
			,[finance_posting_date_key]
			,[finance_vendor_ledger_amount]
			,[finance_vendor_ledger_amount_local_currency]
			,[finance_vendor_ledger_credit_amount]
			,[finance_vendor_ledger_credit_amount_local_currency]
			,[finance_vendor_ledger_closed_by_amount]
			,[finance_vendor_ledger_closed_by_amount_local_currency]
			,[finance_vendor_ledger_closed_by_currency_amount]
			,[finance_vendor_ledger_original_amount]
			,[finance_vendor_ledger_original_amount_local_currency]
			,[finance_vendor_ledger_purchase_local_currency]
			,[finance_vendor_ledger_rem_amount]
			,[finance_vendor_ledger_rem_amount_for_withholding_tax]
			,[finance_vendor_ledger_ODSEffectiveFrom]
			,[DWHSourceSystem]
			,[DWHBatchId]
			,[DWHDMLOperation]
			,[DWHModifiedOn]
			,[DWHCreatedAt]
	  FROM [edw].[fact_finance_vendor_ledger]
			--WHERE DWHIsCurrent = 1
			)
		MERGE INTO TARGET
		USING 
		(
		SELECT isnull(DGLA.[dim_finance_general_ledger_account_key], CASE WHEN ISNULL(src.[finance_vendor_ledger_bal_account_no],'') = '' THEN 0 ELSE -1 END) AS [dim_finance_general_ledger_account_key] -- missing values are assed as empty sting not as a NULL
			,isnull(DBH.[dim_finance_budget_holder_key], CASE WHEN  src.[finance_budget_holder_id] IS NOT NULL THEN -1 ELSE 0 END) AS [dim_finance_budget_holder_key]
			,isnull(DC.[dim_finance_contract_key], CASE WHEN src.[finance_contract_id] IS NOT NULL THEN -1 ELSE 0 END) AS [dim_finance_contract_key]
			,isnull(DP.[dim_department_key], CASE WHEN src.[department_id] IS NOT NULL THEN -1 ELSE 0 END) AS [dim_department_key]
			,isnull(DD.[dim_district_key], CASE WHEN src.[district_id] IS NOT NULL THEN -1 ELSE 0 END) AS [dim_district_key]
			,isnull(DF.[dim_finance_funder_key], CASE WHEN src.[finance_funder_id] IS NOT NULL THEN -1 ELSE 0 END) AS [dim_finance_funder_key]
			,isnull(DFA.[dim_finance_funding_agency_key], CASE WHEN src.[finance_funding_agency_id] IS NOT NULL THEN -1 ELSE 0 END) AS [dim_finance_funding_agency_key]
			,isnull(DL.[dim_location_key], CASE WHEN src.[location_id]  IS NOT NULL THEN -1 ELSE 0 END) AS [dim_location_key]
			,isnull(DR.[dim_region_key], CASE WHEN src.[region_id]  IS NOT NULL THEN -1 ELSE 0 END) AS [dim_region_key]
			,isnull(DSE.[dim_service_key], CASE WHEN src.[service_id] IS NOT NULL THEN -1 ELSE 0 END) AS [dim_service_key]
			,isnull(DV.[dim_finance_vendor_key], CASE WHEN src.[finance_vendor_id] IS NOT NULL THEN -1 ELSE 0 END) AS [dim_finance_vendor_key]
			,isnull(DCY.[dim_company_key], CASE WHEN  src.finance_vendor_ledger_company_name IS NOT NULL THEN -1 ELSE 0 END) AS [dim_company_key]
			,src.[fact_finance_vendor_ledger_partition_key]
			,src.[fact_finance_vendor_ledger_row_key]
			,src.[finance_budget_holder_id]
			,src.[finance_contract_id]
			,src.[department_id]
			,src.[district_id]
			,src.[finance_funder_id]
			,src.[finance_funding_agency_id]
			,src.[location_id]
			,src.[region_id]
			,src.[service_id]
			,src.[finance_vendor_id]
			,src.[user_id]
			,src.[finance_vendor_ledger_dimension_set_id]
			,src.[finance_vendor_ledger_company_name]
			,src.[finance_vendor_ledger_bal_account_no]
			,src.[finance_vendor_ledger_bal_account_type]
			,src.[finance_vendor_ledger_vendor_no]
			,src.[finance_vendor_ledger_vendor_name]
			,src.[finance_vendor_ledger_buy_from_vendor_no]
			,src.[finance_vendor_ledger_global_dimension_1_code]
			,src.[finance_vendor_ledger_no_series]
			,src.[finance_vendor_ledger_open]
			,src.[finance_vendor_ledger_closed_by_entry_no]
			,src.[finance_vendor_ledger_document_no]
			,src.[finance_vendor_ledger_document_type]
			,src.[finance_vendor_ledger_external_document_no]
			,src.[finance_vendor_ledger_description]
			,src.[finance_vendor_ledger_payment_method_code]
			,src.[finance_vendor_ledger_source_code]
			,src.finance_document_date_key
			,src.finance_due_date_key
			,src.finance_posting_date_key
			,src.[finance_vendor_ledger_amount]
			,src.[finance_vendor_ledger_amount_local_currency]
			,src.[finance_vendor_ledger_credit_amount]
			,src.[finance_vendor_ledger_credit_amount_local_currency]
			,src.[finance_vendor_ledger_closed_by_amount]
			,src.[finance_vendor_ledger_closed_by_amount_local_currency]
			,src.[finance_vendor_ledger_closed_by_currency_amount]
			,src.[finance_vendor_ledger_original_amount]
			,src.[finance_vendor_ledger_original_amount_local_currency]
			,src.[finance_vendor_ledger_purchase_local_currency]
			,src.[finance_vendor_ledger_rem_amount]
			,src.[finance_vendor_ledger_rem_amount_for_withholding_tax]
			,src.[finance_vendor_ledger_ODSEffectiveFrom]
			,@SourceSystem AS [DWHSourceSystem]
			,@BatchID AS [DWHBatchId]
			,'I' AS [DWHDMLOperation]
			,@systemCurrentDate AS [DWHCreatedAt]
			,@systemCurrentDate AS [DWHModifiedOn]
		FROM [staging].[ODSETLfact_finance_vendor_ledger] src
		LEFT JOIN [edw].[dim_finance_general_ledger_account] DGLA ON src.[finance_vendor_ledger_bal_account_no] = DGLA.[finance_general_ledger_account_code]
			AND src.[finance_vendor_ledger_company_name] = dgla.[finance_general_ledger_account_company_name]
			AND DGLA.[DWHIsCurrent] = 1
		LEFT JOIN [edw].[dim_finance_budget_holder] DBH ON src.[finance_budget_holder_id] = DBH.[finance_budget_holder_dimension_value_id]
			AND src.finance_vendor_ledger_company_name = dbh.[finance_budget_holder_company_name]
			AND dbh.[DWHIsCurrent] = 1
		LEFT JOIN [edw].[dim_finance_contract] DC ON src.[finance_contract_id] = DC.[finance_contract_dimension_value_id]
			AND src.finance_vendor_ledger_company_name = dc.[finance_contract_company_name]
			AND dc.[DWHIsCurrent] = 1
		LEFT JOIN [edw].[dim_department] DP ON src.[department_id] = Dp.[department_dimension_value_id]
			AND src.finance_vendor_ledger_company_name = dp.[department_company_name]
			AND dp.[DWHIsCurrent] = 1
		LEFT JOIN [edw].[dim_district] DD ON src.[district_id] = DD.district_dimension_value_id
			AND src.finance_vendor_ledger_company_name = DD.[district_company_name]
			AND dd.[DWHIsCurrent] = 1
		LEFT JOIN [edw].[dim_finance_funder] df ON src.[finance_funder_id] = df.[finance_funder_dimension_value_id]
			AND src.finance_vendor_ledger_company_name = df.[finance_funder_company_name]
			AND df.[DWHIsCurrent] = 1
		LEFT JOIN [edw].[dim_finance_funding_agency] DFA ON src.[finance_funding_agency_id] = DFA.[finance_funding_agency_dimension_value_id]
			AND src.finance_vendor_ledger_company_name = DFA.[finance_funding_agency_company_name]
			AND dfa.[DWHIsCurrent] = 1
		LEFT JOIN [edw].[dim_location_new] DL ON cast(src.[location_id] as nvarchar) = DL.business_central_location_id
			AND src.finance_vendor_ledger_company_name = dl.company_name
			AND dl.[DWHIsCurrent] = 1
		LEFT JOIN [edw].[dim_region] DR ON src.[region_id] = DR.[region_dimension_value_id]
			AND src.finance_vendor_ledger_company_name = dr.region_company_name
			AND dr.[DWHIsCurrent] = 1
		LEFT JOIN [edw].[dim_service] DSE ON src.[service_id] = DSE.service_id
			AND src.finance_vendor_ledger_company_name = DSE.[company_name]
			AND dse.[DWHIsCurrent] = 1
		LEFT JOIN [edw].[dim_finance_vendor] DV ON src.[finance_vendor_id] = dv.[finance_vendor_dimension_value_id]
			AND src.finance_vendor_ledger_company_name = dv.[finance_vendor_company_name]
			AND dv.[DWHIsCurrent] = 1
		LEFT JOIN [edw].[dim_company] DCY ON src.finance_vendor_ledger_company_name = DCY.[company_name]
			AND dcy.[DWHIsCurrent] = 1
		)	AS SOURCE
		ON (TARGET.[fact_finance_vendor_ledger_row_key] = SOURCE.[fact_finance_vendor_ledger_row_key]
		and TARGET.[fact_finance_vendor_ledger_partition_key] = SOURCE.[fact_finance_vendor_ledger_partition_key])
		WHEN MATCHED AND EXISTS
			(
				-- Compare the SCD1 columns in source to the target
				-- and return rows if there is any difference
				SELECT   
					 SOURCE.[dim_location_key]
					,SOURCE.[fact_finance_vendor_ledger_partition_key]
					,SOURCE.[fact_finance_vendor_ledger_row_key]
					,SOURCE.[finance_budget_holder_id]
					,SOURCE.[finance_contract_id]
					,SOURCE.[department_id]
					,SOURCE.[district_id]
					,SOURCE.[finance_funder_id]
					,SOURCE.[finance_funding_agency_id]
					,SOURCE.[location_id]
					,SOURCE.[region_id]
					,SOURCE.[service_id]
					,SOURCE.[finance_vendor_id]
					,SOURCE.[user_id]
					,SOURCE.[finance_vendor_ledger_dimension_set_id]
					,SOURCE.[finance_vendor_ledger_company_name]
					,SOURCE.[finance_vendor_ledger_bal_account_no]
					,SOURCE.[finance_vendor_ledger_bal_account_type]
					,SOURCE.[finance_vendor_ledger_vendor_no]
					,SOURCE.[finance_vendor_ledger_vendor_name]
					,SOURCE.[finance_vendor_ledger_buy_from_vendor_no]
					,SOURCE.[finance_vendor_ledger_global_dimension_1_code]
					,SOURCE.[finance_vendor_ledger_no_series]
					,SOURCE.[finance_vendor_ledger_open]
					,SOURCE.[finance_vendor_ledger_closed_by_entry_no]
					,SOURCE.[finance_vendor_ledger_document_no]
					,SOURCE.[finance_vendor_ledger_document_type]
					,SOURCE.[finance_vendor_ledger_external_document_no]
					,SOURCE.[finance_vendor_ledger_description]
					,SOURCE.[finance_vendor_ledger_payment_method_code]
					,SOURCE.[finance_vendor_ledger_source_code]
					,SOURCE.[finance_document_date_key]
					,SOURCE.[finance_due_date_key]
					,SOURCE.[finance_posting_date_key]
					,SOURCE.[finance_vendor_ledger_amount]
					,SOURCE.[finance_vendor_ledger_amount_local_currency]
					,SOURCE.[finance_vendor_ledger_credit_amount]
					,SOURCE.[finance_vendor_ledger_credit_amount_local_currency]
					,SOURCE.[finance_vendor_ledger_closed_by_amount]
					,SOURCE.[finance_vendor_ledger_closed_by_amount_local_currency]
					,SOURCE.[finance_vendor_ledger_closed_by_currency_amount]
					,SOURCE.[finance_vendor_ledger_original_amount]
					,SOURCE.[finance_vendor_ledger_original_amount_local_currency]
					,SOURCE.[finance_vendor_ledger_purchase_local_currency]
					,SOURCE.[finance_vendor_ledger_rem_amount]
					,SOURCE.[finance_vendor_ledger_rem_amount_for_withholding_tax]
								
				EXCEPT
				SELECT  
					 TARGET.[dim_location_key]
					,TARGET.[fact_finance_vendor_ledger_partition_key]
					,TARGET.[fact_finance_vendor_ledger_row_key]
					,TARGET.[finance_budget_holder_id]
					,TARGET.[finance_contract_id]
					,TARGET.[department_id]
					,TARGET.[district_id]
					,TARGET.[finance_funder_id]
					,TARGET.[finance_funding_agency_id]
					,TARGET.[location_id]
					,TARGET.[region_id]
					,TARGET.[service_id]
					,TARGET.[finance_vendor_id]
					,TARGET.[user_id]
					,TARGET.[finance_vendor_ledger_dimension_set_id]
					,TARGET.[finance_vendor_ledger_company_name]
					,TARGET.[finance_vendor_ledger_bal_account_no]
					,TARGET.[finance_vendor_ledger_bal_account_type]
					,TARGET.[finance_vendor_ledger_vendor_no]
					,TARGET.[finance_vendor_ledger_vendor_name]
					,TARGET.[finance_vendor_ledger_buy_from_vendor_no]
					,TARGET.[finance_vendor_ledger_global_dimension_1_code]
					,TARGET.[finance_vendor_ledger_no_series]
					,TARGET.[finance_vendor_ledger_open]
					,TARGET.[finance_vendor_ledger_closed_by_entry_no]
					,TARGET.[finance_vendor_ledger_document_no]
					,TARGET.[finance_vendor_ledger_document_type]
					,TARGET.[finance_vendor_ledger_external_document_no]
					,TARGET.[finance_vendor_ledger_description]
					,TARGET.[finance_vendor_ledger_payment_method_code]
					,TARGET.[finance_vendor_ledger_source_code]
					,TARGET.[finance_document_date_key]
					,TARGET.[finance_due_date_key]
					,TARGET.[finance_posting_date_key]
					,TARGET.[finance_vendor_ledger_amount]
					,TARGET.[finance_vendor_ledger_amount_local_currency]
					,TARGET.[finance_vendor_ledger_credit_amount]
					,TARGET.[finance_vendor_ledger_credit_amount_local_currency]
					,TARGET.[finance_vendor_ledger_closed_by_amount]
					,TARGET.[finance_vendor_ledger_closed_by_amount_local_currency]
					,TARGET.[finance_vendor_ledger_closed_by_currency_amount]
					,TARGET.[finance_vendor_ledger_original_amount]
					,TARGET.[finance_vendor_ledger_original_amount_local_currency]
					,TARGET.[finance_vendor_ledger_purchase_local_currency]
					,TARGET.[finance_vendor_ledger_rem_amount]
					,TARGET.[finance_vendor_ledger_rem_amount_for_withholding_tax]

								
						 ) THEN
			-- if we have difference then updated the edw table
			-- with the new values
			UPDATE SET 
				TARGET.[dim_finance_general_ledger_account_key]=SOURCE.[dim_finance_general_ledger_account_key]
				,TARGET.[dim_finance_budget_holder_key]=SOURCE.[dim_finance_budget_holder_key]
				,TARGET.[dim_finance_contract_key]=SOURCE.[dim_finance_contract_key]
				,TARGET.[dim_department_key]=SOURCE.[dim_department_key]
				,TARGET.[dim_district_key]=SOURCE.[dim_district_key]
				,TARGET.[dim_finance_funder_key]=SOURCE.[dim_finance_funder_key]
				,TARGET.[dim_finance_funding_agency_key]=SOURCE.[dim_finance_funding_agency_key]
				,TARGET.[dim_location_key]=SOURCE.[dim_location_key]
				,TARGET.[dim_region_key]=SOURCE.[dim_region_key]
				,TARGET.[dim_service_key]=SOURCE.[dim_service_key]
				,TARGET.[dim_finance_vendor_key]=SOURCE.[dim_finance_vendor_key]
				,TARGET.[dim_company_key]=SOURCE.[dim_company_key]
				,TARGET.[fact_finance_vendor_ledger_partition_key]=SOURCE.[fact_finance_vendor_ledger_partition_key]
				,TARGET.[fact_finance_vendor_ledger_row_key]=SOURCE.[fact_finance_vendor_ledger_row_key]
				,TARGET.[finance_budget_holder_id]=SOURCE.[finance_budget_holder_id]
				,TARGET.[finance_contract_id]=SOURCE.[finance_contract_id]
				,TARGET.[department_id]=SOURCE.[department_id]
				,TARGET.[district_id]=SOURCE.[district_id]
				,TARGET.[finance_funder_id]=SOURCE.[finance_funder_id]
				,TARGET.[finance_funding_agency_id]=SOURCE.[finance_funding_agency_id]
				,TARGET.[location_id]=SOURCE.[location_id]
				,TARGET.[region_id]=SOURCE.[region_id]
				,TARGET.[service_id]=SOURCE.[service_id]
				,TARGET.[finance_vendor_id]=SOURCE.[finance_vendor_id]
				,TARGET.[user_id]=SOURCE.[user_id]
				,TARGET.[finance_vendor_ledger_dimension_set_id]=SOURCE.[finance_vendor_ledger_dimension_set_id]
				,TARGET.[finance_vendor_ledger_company_name]=SOURCE.[finance_vendor_ledger_company_name]
				,TARGET.[finance_vendor_ledger_bal_account_no]=SOURCE.[finance_vendor_ledger_bal_account_no]
				,TARGET.[finance_vendor_ledger_bal_account_type]=SOURCE.[finance_vendor_ledger_bal_account_type]
				,TARGET.[finance_vendor_ledger_vendor_no]=SOURCE.[finance_vendor_ledger_vendor_no]
				,TARGET.[finance_vendor_ledger_vendor_name]=SOURCE.[finance_vendor_ledger_vendor_name]
				,TARGET.[finance_vendor_ledger_buy_from_vendor_no]=SOURCE.[finance_vendor_ledger_buy_from_vendor_no]
				,TARGET.[finance_vendor_ledger_global_dimension_1_code]=SOURCE.[finance_vendor_ledger_global_dimension_1_code]
				,TARGET.[finance_vendor_ledger_no_series]=SOURCE.[finance_vendor_ledger_no_series]
				,TARGET.[finance_vendor_ledger_open]=SOURCE.[finance_vendor_ledger_open]
				,TARGET.[finance_vendor_ledger_closed_by_entry_no]=SOURCE.[finance_vendor_ledger_closed_by_entry_no]
				,TARGET.[finance_vendor_ledger_document_no]=SOURCE.[finance_vendor_ledger_document_no]
				,TARGET.[finance_vendor_ledger_document_type]=SOURCE.[finance_vendor_ledger_document_type]
				,TARGET.[finance_vendor_ledger_external_document_no]=SOURCE.[finance_vendor_ledger_external_document_no]
				,TARGET.[finance_vendor_ledger_description]=SOURCE.[finance_vendor_ledger_description]
				,TARGET.[finance_vendor_ledger_payment_method_code]=SOURCE.[finance_vendor_ledger_payment_method_code]
				,TARGET.[finance_vendor_ledger_source_code]=SOURCE.[finance_vendor_ledger_source_code]
				,TARGET.[finance_document_date_key]=SOURCE.[finance_document_date_key]
				,TARGET.[finance_due_date_key]=SOURCE.[finance_due_date_key]
				,TARGET.[finance_posting_date_key]=SOURCE.[finance_posting_date_key]
				,TARGET.[finance_vendor_ledger_amount]=SOURCE.[finance_vendor_ledger_amount]
				,TARGET.[finance_vendor_ledger_amount_local_currency]=SOURCE.[finance_vendor_ledger_amount_local_currency]
				,TARGET.[finance_vendor_ledger_credit_amount]=SOURCE.[finance_vendor_ledger_credit_amount]
				,TARGET.[finance_vendor_ledger_credit_amount_local_currency]=SOURCE.[finance_vendor_ledger_credit_amount_local_currency]
				,TARGET.[finance_vendor_ledger_closed_by_amount]=SOURCE.[finance_vendor_ledger_closed_by_amount]
				,TARGET.[finance_vendor_ledger_closed_by_amount_local_currency]=SOURCE.[finance_vendor_ledger_closed_by_amount_local_currency]
				,TARGET.[finance_vendor_ledger_closed_by_currency_amount]=SOURCE.[finance_vendor_ledger_closed_by_currency_amount]
				,TARGET.[finance_vendor_ledger_original_amount]=SOURCE.[finance_vendor_ledger_original_amount]
				,TARGET.[finance_vendor_ledger_original_amount_local_currency]=SOURCE.[finance_vendor_ledger_original_amount_local_currency]
				,TARGET.[finance_vendor_ledger_purchase_local_currency]=SOURCE.[finance_vendor_ledger_purchase_local_currency]
				,TARGET.[finance_vendor_ledger_rem_amount]=SOURCE.[finance_vendor_ledger_rem_amount]
				,TARGET.[finance_vendor_ledger_rem_amount_for_withholding_tax]=SOURCE.[finance_vendor_ledger_rem_amount_for_withholding_tax]
				,TARGET.[finance_vendor_ledger_ODSEffectiveFrom]=SOURCE.[finance_vendor_ledger_ODSEffectiveFrom]
				,TARGET.[DWHSourceSystem] = @SourceSystem
				,TARGET.[DWHModifiedOn] = @systemCurrentDate
				,TARGET.[DWHBatchId] = @BatchID
				,TARGET.[DWHDMLOperation] = 'U'
			 -- Insert new records
	   when not matched by target then 
		insert 
		(
			 [dim_finance_general_ledger_account_key]
			,[dim_finance_budget_holder_key]
			,[dim_finance_contract_key]
			,[dim_department_key]
			,[dim_district_key]
			,[dim_finance_funder_key]
			,[dim_finance_funding_agency_key]
			,[dim_location_key]
			,[dim_region_key]
			,[dim_service_key]
			,[dim_finance_vendor_key]
			,[dim_company_key]
			,[fact_finance_vendor_ledger_partition_key]
			,[fact_finance_vendor_ledger_row_key]
			,[finance_budget_holder_id]
			,[finance_contract_id]
			,[department_id]
			,[district_id]
			,[finance_funder_id]
			,[finance_funding_agency_id]
			,[location_id]
			,[region_id]
			,[service_id]
			,[finance_vendor_id]
			,[user_id]
			,[finance_vendor_ledger_dimension_set_id]
			,[finance_vendor_ledger_company_name]
			,[finance_vendor_ledger_bal_account_no]
			,[finance_vendor_ledger_bal_account_type]
			,[finance_vendor_ledger_vendor_no]
			,[finance_vendor_ledger_vendor_name]
			,[finance_vendor_ledger_buy_from_vendor_no]
			,[finance_vendor_ledger_global_dimension_1_code]
			,[finance_vendor_ledger_no_series]
			,[finance_vendor_ledger_open]
			,[finance_vendor_ledger_closed_by_entry_no]
			,[finance_vendor_ledger_document_no]
			,[finance_vendor_ledger_document_type]
			,[finance_vendor_ledger_external_document_no]
			,[finance_vendor_ledger_description]
			,[finance_vendor_ledger_payment_method_code]
			,[finance_vendor_ledger_source_code]
			,[finance_document_date_key]
			,[finance_due_date_key]
			,[finance_posting_date_key]
			,[finance_vendor_ledger_amount]
			,[finance_vendor_ledger_amount_local_currency]
			,[finance_vendor_ledger_credit_amount]
			,[finance_vendor_ledger_credit_amount_local_currency]
			,[finance_vendor_ledger_closed_by_amount]
			,[finance_vendor_ledger_closed_by_amount_local_currency]
			,[finance_vendor_ledger_closed_by_currency_amount]
			,[finance_vendor_ledger_original_amount]
			,[finance_vendor_ledger_original_amount_local_currency]
			,[finance_vendor_ledger_purchase_local_currency]
			,[finance_vendor_ledger_rem_amount]
			,[finance_vendor_ledger_rem_amount_for_withholding_tax]
			,[finance_vendor_ledger_ODSEffectiveFrom]
			,[DWHSourceSystem]
			,[DWHBatchId]
			,[DWHDMLOperation]
			,[DWHModifiedOn]
			,[DWHCreatedAt]
		)
		values
		(
			 SOURCE.[dim_finance_general_ledger_account_key]
			,SOURCE.[dim_finance_budget_holder_key]
			,SOURCE.[dim_finance_contract_key]
			,SOURCE.[dim_department_key]
			,SOURCE.[dim_district_key]
			,SOURCE.[dim_finance_funder_key]
			,SOURCE.[dim_finance_funding_agency_key]
			,SOURCE.[dim_location_key]
			,SOURCE.[dim_region_key]
			,SOURCE.[dim_service_key]
			,SOURCE.[dim_finance_vendor_key]
			,SOURCE.[dim_company_key]
			,SOURCE.[fact_finance_vendor_ledger_partition_key]
			,SOURCE.[fact_finance_vendor_ledger_row_key]
			,SOURCE.[finance_budget_holder_id]
			,SOURCE.[finance_contract_id]
			,SOURCE.[department_id]
			,SOURCE.[district_id]
			,SOURCE.[finance_funder_id]
			,SOURCE.[finance_funding_agency_id]
			,SOURCE.[location_id]
			,SOURCE.[region_id]
			,SOURCE.[service_id]
			,SOURCE.[finance_vendor_id]
			,SOURCE.[user_id]
			,SOURCE.[finance_vendor_ledger_dimension_set_id]
			,SOURCE.[finance_vendor_ledger_company_name]
			,SOURCE.[finance_vendor_ledger_bal_account_no]
			,SOURCE.[finance_vendor_ledger_bal_account_type]
			,SOURCE.[finance_vendor_ledger_vendor_no]
			,SOURCE.[finance_vendor_ledger_vendor_name]
			,SOURCE.[finance_vendor_ledger_buy_from_vendor_no]
			,SOURCE.[finance_vendor_ledger_global_dimension_1_code]
			,SOURCE.[finance_vendor_ledger_no_series]
			,SOURCE.[finance_vendor_ledger_open]
			,SOURCE.[finance_vendor_ledger_closed_by_entry_no]
			,SOURCE.[finance_vendor_ledger_document_no]
			,SOURCE.[finance_vendor_ledger_document_type]
			,SOURCE.[finance_vendor_ledger_external_document_no]
			,SOURCE.[finance_vendor_ledger_description]
			,SOURCE.[finance_vendor_ledger_payment_method_code]
			,SOURCE.[finance_vendor_ledger_source_code]
			,SOURCE.[finance_document_date_key]
			,SOURCE.[finance_due_date_key]
			,SOURCE.[finance_posting_date_key]
			,SOURCE.[finance_vendor_ledger_amount]
			,SOURCE.[finance_vendor_ledger_amount_local_currency]
			,SOURCE.[finance_vendor_ledger_credit_amount]
			,SOURCE.[finance_vendor_ledger_credit_amount_local_currency]
			,SOURCE.[finance_vendor_ledger_closed_by_amount]
			,SOURCE.[finance_vendor_ledger_closed_by_amount_local_currency]
			,SOURCE.[finance_vendor_ledger_closed_by_currency_amount]
			,SOURCE.[finance_vendor_ledger_original_amount]
			,SOURCE.[finance_vendor_ledger_original_amount_local_currency]
			,SOURCE.[finance_vendor_ledger_purchase_local_currency]
			,SOURCE.[finance_vendor_ledger_rem_amount]
			,SOURCE.[finance_vendor_ledger_rem_amount_for_withholding_tax]
			,SOURCE.[finance_vendor_ledger_ODSEffectiveFrom]
			,SOURCE.[DWHSourceSystem]
			,SOURCE.[DWHBatchId]
			,SOURCE.[DWHDMLOperation]
			,SOURCE.[DWHModifiedOn]
			,SOURCE.[DWHCreatedAt]
		);


		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[fact_finance_vendor_ledger]
		--where [DWHEffectiveTo] = @SystemDefaultEffectiveTo;

		commit transaction;
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