


/**********************************************************************************************************
 Procedure	[edw].[Updateedwfact_finance_customer_ledger] 
 Author		
 Created		
 Purpose		
		
 Call By		EDW Pipeline '30_Load_From_ODS'
 Parameter(s)  None 
 =========================================================================================================

REVISIONS:
Version	 Date		   Author			    Description
-------  ------------  ---------------	--------------------------
1.0		 ?			   ?				Initial creation of stored procedure
1.1		 2023-08-22	   Glenn McLeod		Rename source tables
1.2		 2023-09-26	   Glenn McLeod		Update to identify difference between N/A and Unknown dim records
1.3		 2024-10-29	   Greg Nuthall		Changed the account lookup from budget holder to account number
1.4		 2026-04-28    Pankaj Bhatt		Update join for location dim

**********************************************************************************************************/

CREATE procedure [edw].[Updateedwfact_finance_customer_ledger] 
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
	declare @SourceSystem nvarchar(120) = '[Staging].[ODSETLfact_finance_customer_ledger]';

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

	begin transaction;
	begin try


		
		-- Do not run if there are no records in source
		select @stagedRecords = count(1) from [Staging].[ODSETLfact_finance_customer_ledger];
		if( @stagedRecords = 0 )
		begin
			select 
				 @targetRecords = count(1) 
				,@deletedRecords = sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			from [edw].[fact_finance_customer_ledger];
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
			[finance_customer_ledger_document_date_key]
			,[finance_customer_ledger_posting_date_key]
			,[finance_customer_ledger_due_date_key]
			,[dim_finance_general_ledger_account_key]
			,[dim_finance_customer_key]
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
	  		,[fact_finance_customer_ledger_partition_key]
			,[fact_finance_customer_ledger_row_key]
			,[finance_customer_ledger_customer_id]
			,[finance_customer_ledger_budget_holder_id]
			,[finance_customer_ledger_contract_id]
			,[finance_customer_ledger_department_id]
			,finance_customer_ledger_district_id
			,finance_customer_ledger_funder_id
			,finance_customer_ledger_funding_agency_id
			,finance_customer_ledger_location_id
			,finance_customer_ledger_region_id
			,finance_customer_ledger_service_id
			,finance_customer_ledger_vendor_id
			,finance_customer_ledger_company_name
			,[finance_customer_ledger_amount]
			,[finance_customer_ledger_amount_local_currency]
			,[finance_customer_ledger_bal_account_no]
			,[finance_customer_ledger_bal_account_type]
			,[finance_customer_ledger_closed_by_amount]
			,[finance_customer_ledger_closed_by_amount_local_currency]
			,[finance_customer_ledger_closed_by_currency_amount]
			,[finance_customer_ledger_closed_by_currency_code]
			,[finance_customer_ledger_credit_amount]
			,[finance_customer_ledger_credit_amount_local_currency]
			,[finance_customer_ledger_customer_no]
			,[finance_customer_ledger_customer_posting_group]
			,[finance_customer_ledger_debit_amount]
			,[finance_customer_ledger_description]
			,[finance_customer_ledger_dimension_set_id]
			--,[finance_customer_ledger_document_date]
			,[finance_customer_ledger_document_no]
			,[finance_customer_ledger_document_type]
			--,[finance_customer_ledger_due_date]
			,[finance_customer_ledger_entry_no]
			,[finance_customer_ledger_no_series]
			,[finance_customer_ledger_open]
			,[finance_customer_ledger_original_amount]
			,[finance_customer_ledger_payment_method_code]
			,[finance_customer_ledger_payment_prediction]
			,[finance_customer_ledger_payment_reference]
			--,[finance_customer_ledger_posting_date]
			,[finance_customer_ledger_profit_local_currency]
			,[finance_customer_ledger_reason_code]
			,[finance_customer_ledger_rem_amt]
			,[finance_customer_ledger_rem_amt_for_wht]
			,[finance_customer_ledger_remaining_amount]
			,[finance_customer_ledger_reversed]
			,[finance_customer_ledger_reversed_entry_no]
			,[finance_customer_ledger_sales_local_currency]
			,[finance_customer_ledger_sell_to_customer_no]
			,[finance_customer_ledger_source_code]
			,[finance_customer_ledger_transaction_no]
			,[finance_customer_ledger_user_id]
			,[finance_customer_ledger_withholding_tax_amount]
			,[finance_customer_ledger_withholding_tax_payment]
			,[finance_customer_ledger_ODSEffectiveFrom]
			,[DWHSourceSystem]
			,[DWHBatchId]
			,[DWHDMLOperation]
			,[DWHCreatedAt]
			,[DWHModifiedOn]
	  FROM [edw].[fact_finance_customer_ledger]
			--WHERE DWHIsCurrent = 1
			)
		MERGE INTO TARGET
		USING 
		(
		SELECT
			Convert(CHAR(8),src.[finance_customer_ledger_document_date],112) AS finance_customer_ledger_document_date_key
			,Convert(CHAR(8),src.[finance_customer_ledger_posting_date],112) AS finance_customer_ledger_posting_date_key
			,Convert(CHAR(8),src.[finance_customer_ledger_due_date],112) AS finance_customer_ledger_due_date_key
			,isnull(GLA.[dim_finance_general_ledger_account_key],CASE WHEN isnull(src.finance_customer_ledger_bal_account_no,'') <> '' THEN -1 ELSE 0 END) as [dim_finance_general_ledger_account_key]
			,isnull(DFC.[dim_finance_customer_key],CASE WHEN src.[finance_customer_ledger_customer_id]  IS NOT NULL THEN -1 ELSE 0 END) as [dim_finance_customer_key]
			,isnull(DBH.[dim_finance_budget_holder_key],CASE WHEN src.[finance_customer_ledger_budget_holder_id] IS NOT NULL THEN -1 ELSE 0 END) as [dim_finance_budget_holder_key]
			,isnull(DC.[dim_finance_contract_key],CASE WHEN src.[finance_customer_ledger_contract_id] IS NOT NULL THEN -1 ELSE 0 END) as [dim_finance_contract_key]
			,isnull(DP.[dim_department_key],CASE WHEN src.[finance_customer_ledger_department_id] IS NOT NULL THEN -1 ELSE 0 END) as [dim_department_key]
			,isnull(DD.[dim_district_key],CASE WHEN src.[finance_customer_ledger_district_id] IS NOT NULL THEN -1 ELSE 0 END) as [dim_district_key]
			,isnull(DF.[dim_finance_funder_key],CASE WHEN src.[finance_customer_ledger_funder_id] IS NOT NULL THEN -1 ELSE 0 END) as [dim_finance_funder_key]
			,isnull(DFA.[dim_finance_funding_agency_key],CASE WHEN src.[finance_customer_ledger_funding_agency_id]  IS NOT NULL THEN -1 ELSE 0 END) as [dim_finance_funding_agency_key]
			,isnull(DL.[dim_location_key],CASE WHEN src.[finance_customer_ledger_location_id] IS NOT NULL THEN -1 ELSE 0 END) as [dim_location_key]
			,isnull(DR.[dim_region_key],CASE WHEN src.[finance_customer_ledger_region_id] IS NOT NULL THEN -1 ELSE 0 END) as [dim_region_key]
			,isnull(DSE.[dim_service_key],CASE WHEN src.[finance_customer_ledger_service_id] IS NOT NULL THEN -1 ELSE 0 END) as [dim_service_key]
			,isnull(DV.[dim_finance_vendor_key],CASE WHEN src.[finance_customer_ledger_vendor_id] IS NOT NULL THEN -1 ELSE 0 END) as [dim_finance_vendor_key]
			,isnull(DCY.[dim_company_key],CASE WHEN src.finance_customer_ledger_company_name IS NOT NULL THEN -1 ELSE 0 END) as [dim_company_key]
			,src.[finance_customer_ledger_customer_id]
			,src.[finance_customer_ledger_budget_holder_id]
			,src.[finance_customer_ledger_contract_id]
			,src.[finance_customer_ledger_department_id]
			,src.[finance_customer_ledger_district_id]
			,src.[finance_customer_ledger_funder_id]
			,src.[finance_customer_ledger_funding_agency_id]
			,src.[finance_customer_ledger_location_id]
			,src.[finance_customer_ledger_region_id]
			,src.[finance_customer_ledger_service_id]
			,src.[finance_customer_ledger_vendor_id]
			,src.[finance_customer_ledger_company_name]
			,src.[fact_finance_customer_ledger_partition_key]
			,src.[fact_finance_customer_ledger_row_key]
			,src.[finance_customer_ledger_amount]
			,src.[finance_customer_ledger_amount_local_currency]
			,src.[finance_customer_ledger_bal_account_no]
			,src.[finance_customer_ledger_bal_account_type]
			,src.[finance_customer_ledger_closed_by_amount]
			,src.[finance_customer_ledger_closed_by_amount_local_currency]
			,src.[finance_customer_ledger_closed_by_currency_amount]
			,src.[finance_customer_ledger_closed_by_currency_code]
			,src.[finance_customer_ledger_credit_amount]
			,src.[finance_customer_ledger_credit_amount_local_currency]
			,src.[finance_customer_ledger_customer_no]
			,src.[finance_customer_ledger_customer_posting_group]
			,src.[finance_customer_ledger_debit_amount]
			,src.[finance_customer_ledger_description]
			,src.[finance_customer_ledger_dimension_set_id]
			--,src.[finance_customer_ledger_document_date]
			,src.[finance_customer_ledger_document_no]
			,src.[finance_customer_ledger_document_type]
			--,src.[finance_customer_ledger_due_date]
			,src.[finance_customer_ledger_entry_no]
			,src.[finance_customer_ledger_no_series]
			,src.[finance_customer_ledger_open]
			,src.[finance_customer_ledger_original_amount]
			,src.[finance_customer_ledger_payment_method_code]
			,src.[finance_customer_ledger_payment_prediction]
			,src.[finance_customer_ledger_payment_reference]
			--,src.[finance_customer_ledger_posting_date]
			,src.[finance_customer_ledger_profit_local_currency]
			,src.[finance_customer_ledger_reason_code]
			,src.[finance_customer_ledger_rem_amt]
			,src.[finance_customer_ledger_rem_amt_for_wht]
			,src.[finance_customer_ledger_remaining_amount]
			,src.[finance_customer_ledger_reversed]
			,src.[finance_customer_ledger_reversed_entry_no]
			,src.[finance_customer_ledger_sales_local_currency]
			,src.[finance_customer_ledger_sell_to_customer_no]
			,src.[finance_customer_ledger_source_code]
			,src.[finance_customer_ledger_transaction_no]
			,src.[finance_customer_ledger_user_id]
			,src.[finance_customer_ledger_withholding_tax_amount]
			,src.[finance_customer_ledger_withholding_tax_payment]
			,src.[finance_customer_ledger_ODSEffectiveFrom]
		  ,@SourceSystem as [DWHSourceSystem]
		  ,@BatchID as [DWHBatchId]
		  ,'I' as [DWHDMLOperation]
		  ,@systemCurrentDate as [DWHCreatedAt]
		  ,@systemCurrentDate as [DWHModifiedOn]
	  FROM [Staging].[ODSETLfact_finance_customer_ledger] src
		LEFT JOIN [edw].[dim_finance_general_ledger_account] gla
			on src.finance_customer_ledger_bal_account_no=gla.[finance_general_ledger_account_code]
			and src.finance_customer_ledger_company_name=gla.[finance_general_ledger_account_company_name]
			and gla.dwhiscurrent=1
		LEFT JOIN [edw].[dim_finance_customer] DFC
			on src.[finance_customer_ledger_customer_id] = DFC.[finance_customer_dimension_value_id]
			and src.finance_customer_ledger_company_name=dfc.[finance_customer_company_name]
			and DFC.[DWHIsCurrent] = 1 
		LEFT JOIN [edw].[dim_finance_budget_holder] DBH
			on src.[finance_customer_ledger_budget_holder_id]=DBH.[finance_budget_holder_dimension_value_id]
			and src.finance_customer_ledger_company_name=dbh.[finance_budget_holder_company_name]
			and dbh.[DWHIsCurrent] = 1 
		LEFT JOIN [edw].[dim_finance_contract] DC
			on src.[finance_customer_ledger_contract_id]=DC.[finance_contract_dimension_value_id]
			and src.finance_customer_ledger_company_name=dc.[finance_contract_company_name]
			and dc.[DWHIsCurrent] = 1 
		LEFT JOIN [edw].[dim_department] DP
			on src.[finance_customer_ledger_department_id]=Dp.[department_dimension_value_id]
			and src.finance_customer_ledger_company_name=dp.[department_company_name]
			and dp.[DWHIsCurrent] = 1 
		LEFT JOIN [edw].[dim_district] DD
			on src.[finance_customer_ledger_district_id]=DD.district_dimension_value_id
			and src.finance_customer_ledger_company_name=DD.[district_company_name]
			and dd.[DWHIsCurrent] = 1 
		LEFT JOIN [edw].[dim_finance_funder] df
			on src.[finance_customer_ledger_funder_id]=df.[finance_funder_dimension_value_id]
			and src.finance_customer_ledger_company_name=df.[finance_funder_company_name]
			and df.[DWHIsCurrent] = 1 
		LEFT JOIN [edw].[dim_finance_funding_agency] DFA
			on src.[finance_customer_ledger_funding_agency_id]=DFA.[finance_funding_agency_dimension_value_id]
			and src.finance_customer_ledger_company_name=DFA.[finance_funding_agency_company_name]
			and dfa.[DWHIsCurrent] = 1 
		LEFT JOIN [edw].[dim_location_new] DL
			on cast(src.[finance_customer_ledger_location_id] as nvarchar)=DL.business_central_location_id
			and src.finance_customer_ledger_company_name=dl.company_name
			and dl.[DWHIsCurrent] = 1 
		LEFT JOIN [edw].[dim_region] DR
			on src.[finance_customer_ledger_region_id]=DR.[region_dimension_value_id]
			and src.finance_customer_ledger_company_name=dr.region_company_name
			and dr.[DWHIsCurrent] = 1 
		LEFT JOIN [edw].[dim_service] DSE
			on src.[finance_customer_ledger_service_id]=DSE.service_id
			and src.finance_customer_ledger_company_name=DSE.[company_name]
			and dse.[DWHIsCurrent] = 1 
		LEFT JOIN [edw].[dim_finance_vendor] DV
			on src.[finance_customer_ledger_vendor_id]=dv.[finance_vendor_dimension_value_id]
			and src.finance_customer_ledger_company_name=dv.[finance_vendor_company_name]
			and dv.[DWHIsCurrent] = 1 
		LEFT JOIN [edw].[dim_company] DCY
			on src.finance_customer_ledger_company_name=DCY.company_name
			and dcy.[DWHIsCurrent] = 1 
		)	AS SOURCE
		ON (TARGET.[fact_finance_customer_ledger_row_key] = SOURCE.[fact_finance_customer_ledger_row_key]
		and TARGET.[fact_finance_customer_ledger_partition_key] = SOURCE.[fact_finance_customer_ledger_partition_key])
		WHEN MATCHED AND EXISTS
			(
				-- Compare the SCD1 columns in source to the target
				-- and return rows if there is any difference
				SELECT   
					SOURCE.[dim_location_key]
					,SOURCE.[fact_finance_customer_ledger_partition_key]
					,SOURCE.[fact_finance_customer_ledger_row_key]
					,SOURCE.[finance_customer_ledger_document_date_key]
					,SOURCE.[finance_customer_ledger_posting_date_key]
					,SOURCE.[finance_customer_ledger_due_date_key]
					,SOURCE.[finance_customer_ledger_customer_id]
					,SOURCE.[finance_customer_ledger_budget_holder_id]
					,SOURCE.[finance_customer_ledger_contract_id]
					,SOURCE.[finance_customer_ledger_department_id]
					,SOURCE.[finance_customer_ledger_district_id]
					,SOURCE.[finance_customer_ledger_funder_id]
					,SOURCE.[finance_customer_ledger_funding_agency_id]
					,SOURCE.[finance_customer_ledger_location_id]
					,SOURCE.[finance_customer_ledger_region_id]
					,SOURCE.[finance_customer_ledger_service_id]
					,SOURCE.[finance_customer_ledger_vendor_id]
					,SOURCE.[finance_customer_ledger_company_name]
					,SOURCE.[finance_customer_ledger_amount]
					,SOURCE.[finance_customer_ledger_amount_local_currency]
					,SOURCE.[finance_customer_ledger_bal_account_no]
					,SOURCE.[finance_customer_ledger_bal_account_type]
					,SOURCE.[finance_customer_ledger_closed_by_amount]
					,SOURCE.[finance_customer_ledger_closed_by_amount_local_currency]
					,SOURCE.[finance_customer_ledger_closed_by_currency_amount]
					,SOURCE.[finance_customer_ledger_closed_by_currency_code]
					,SOURCE.[finance_customer_ledger_credit_amount]
					,SOURCE.[finance_customer_ledger_credit_amount_local_currency]
					,SOURCE.[finance_customer_ledger_customer_no]
					,SOURCE.[finance_customer_ledger_customer_posting_group]
					,SOURCE.[finance_customer_ledger_debit_amount]
					,SOURCE.[finance_customer_ledger_description]
					,SOURCE.[finance_customer_ledger_dimension_set_id]
					--,SOURCE.[finance_customer_ledger_document_date]
					,SOURCE.[finance_customer_ledger_document_no]
					,SOURCE.[finance_customer_ledger_document_type]
					--,SOURCE.[finance_customer_ledger_due_date]
					,SOURCE.[finance_customer_ledger_entry_no]
					,SOURCE.[finance_customer_ledger_no_series]
					,SOURCE.[finance_customer_ledger_open]
					,SOURCE.[finance_customer_ledger_original_amount]
					,SOURCE.[finance_customer_ledger_payment_method_code]
					,SOURCE.[finance_customer_ledger_payment_prediction]
					,SOURCE.[finance_customer_ledger_payment_reference]
					--,SOURCE.[finance_customer_ledger_posting_date]
					,SOURCE.[finance_customer_ledger_profit_local_currency]
					,SOURCE.[finance_customer_ledger_reason_code]
					,SOURCE.[finance_customer_ledger_rem_amt]
					,SOURCE.[finance_customer_ledger_rem_amt_for_wht]
					,SOURCE.[finance_customer_ledger_remaining_amount]
					,SOURCE.[finance_customer_ledger_reversed]
					,SOURCE.[finance_customer_ledger_reversed_entry_no]
					,SOURCE.[finance_customer_ledger_sales_local_currency]
					,SOURCE.[finance_customer_ledger_sell_to_customer_no]
					,SOURCE.[finance_customer_ledger_source_code]
					,SOURCE.[finance_customer_ledger_transaction_no]
					,SOURCE.[finance_customer_ledger_user_id]
					,SOURCE.[finance_customer_ledger_withholding_tax_amount]
					,SOURCE.[finance_customer_ledger_withholding_tax_payment]
					--,SOURCE.[finance_customer_ledger_ODSEffectiveFrom]
								
				EXCEPT
				SELECT  
					TARGET.[dim_location_key]
					,TARGET.fact_finance_customer_ledger_partition_key
					,TARGET.fact_finance_customer_ledger_row_key
					,TARGET.finance_customer_ledger_document_date_key
					,TARGET.finance_customer_ledger_posting_date_key
					,TARGET.finance_customer_ledger_due_date_key
					,TARGET.finance_customer_ledger_customer_id
					,TARGET.finance_customer_ledger_budget_holder_id
					,TARGET.finance_customer_ledger_contract_id
					,TARGET.finance_customer_ledger_department_id
					,TARGET.finance_customer_ledger_district_id
					,TARGET.finance_customer_ledger_funder_id
					,TARGET.finance_customer_ledger_funding_agency_id
					,TARGET.finance_customer_ledger_location_id
					,TARGET.finance_customer_ledger_region_id
					,TARGET.finance_customer_ledger_service_id
					,TARGET.finance_customer_ledger_vendor_id
					,TARGET.finance_customer_ledger_company_name
					,TARGET.[finance_customer_ledger_amount]
					,TARGET.[finance_customer_ledger_amount_local_currency]
					,TARGET.[finance_customer_ledger_bal_account_no]
					,TARGET.[finance_customer_ledger_bal_account_type]
					,TARGET.[finance_customer_ledger_closed_by_amount]
					,TARGET.[finance_customer_ledger_closed_by_amount_local_currency]
					,TARGET.[finance_customer_ledger_closed_by_currency_amount]
					,TARGET.[finance_customer_ledger_closed_by_currency_code]
					,TARGET.[finance_customer_ledger_credit_amount]
					,TARGET.[finance_customer_ledger_credit_amount_local_currency]
					,TARGET.[finance_customer_ledger_customer_no]
					,TARGET.[finance_customer_ledger_customer_posting_group]
					,TARGET.[finance_customer_ledger_debit_amount]
					,TARGET.[finance_customer_ledger_description]
					,TARGET.[finance_customer_ledger_dimension_set_id]
					--,TARGET.[finance_customer_ledger_document_date]
					,TARGET.[finance_customer_ledger_document_no]
					,TARGET.[finance_customer_ledger_document_type]
					--,TARGET.[finance_customer_ledger_due_date]
					,TARGET.[finance_customer_ledger_entry_no]
					,TARGET.[finance_customer_ledger_no_series]
					,TARGET.[finance_customer_ledger_open]
					,TARGET.[finance_customer_ledger_original_amount]
					,TARGET.[finance_customer_ledger_payment_method_code]
					,TARGET.[finance_customer_ledger_payment_prediction]
					,TARGET.[finance_customer_ledger_payment_reference]
					--,TARGET.[finance_customer_ledger_posting_date]
					,TARGET.[finance_customer_ledger_profit_local_currency]
					,TARGET.[finance_customer_ledger_reason_code]
					,TARGET.[finance_customer_ledger_rem_amt]
					,TARGET.[finance_customer_ledger_rem_amt_for_wht]
					,TARGET.[finance_customer_ledger_remaining_amount]
					,TARGET.[finance_customer_ledger_reversed]
					,TARGET.[finance_customer_ledger_reversed_entry_no]
					,TARGET.[finance_customer_ledger_sales_local_currency]
					,TARGET.[finance_customer_ledger_sell_to_customer_no]
					,TARGET.[finance_customer_ledger_source_code]
					,TARGET.[finance_customer_ledger_transaction_no]
					,TARGET.[finance_customer_ledger_user_id]
					,TARGET.[finance_customer_ledger_withholding_tax_amount]
					,TARGET.[finance_customer_ledger_withholding_tax_payment]
					--,TARGET.[finance_customer_ledger_ODSEffectiveFrom]

								
						 ) THEN
			-- if we have difference then updated the edw table
			-- with the new values
			UPDATE SET 
				TARGET.[finance_customer_ledger_document_date_key]=SOURCE.[finance_customer_ledger_document_date_key]
				,TARGET.[finance_customer_ledger_posting_date_key]=SOURCE.[finance_customer_ledger_posting_date_key]
				,TARGET.[finance_customer_ledger_due_date_key]=SOURCE.[finance_customer_ledger_due_date_key]
				,TARGET.[dim_finance_general_ledger_account_key]=SOURCE.[dim_finance_general_ledger_account_key]
				,TARGET.[dim_finance_customer_key]=SOURCE.[dim_finance_customer_key]
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
				,TARGET.[fact_finance_customer_ledger_partition_key]=SOURCE.[fact_finance_customer_ledger_partition_key]
				,TARGET.[fact_finance_customer_ledger_row_key]=SOURCE.[fact_finance_customer_ledger_row_key]
				,TARGET.finance_customer_ledger_customer_id=SOURCE.finance_customer_ledger_customer_id
				,TARGET.finance_customer_ledger_budget_holder_id=SOURCE.finance_customer_ledger_budget_holder_id
				,TARGET.finance_customer_ledger_contract_id=SOURCE.finance_customer_ledger_contract_id
				,TARGET.finance_customer_ledger_department_id=SOURCE.finance_customer_ledger_department_id
				,TARGET.finance_customer_ledger_district_id=SOURCE.finance_customer_ledger_district_id
				,TARGET.finance_customer_ledger_funder_id=SOURCE.finance_customer_ledger_funder_id
				,TARGET.finance_customer_ledger_funding_agency_id=SOURCE.finance_customer_ledger_funding_agency_id
				,TARGET.finance_customer_ledger_location_id=SOURCE.finance_customer_ledger_location_id
				,TARGET.finance_customer_ledger_region_id=SOURCE.finance_customer_ledger_region_id
				,TARGET.finance_customer_ledger_service_id=SOURCE.finance_customer_ledger_service_id
				,TARGET.finance_customer_ledger_vendor_id=SOURCE.finance_customer_ledger_vendor_id
				,TARGET.finance_customer_ledger_company_name=SOURCE.finance_customer_ledger_company_name
				,TARGET.[finance_customer_ledger_amount]=SOURCE.[finance_customer_ledger_amount]
				,TARGET.[finance_customer_ledger_amount_local_currency]=SOURCE.[finance_customer_ledger_amount_local_currency]
				,TARGET.[finance_customer_ledger_bal_account_no]=SOURCE.[finance_customer_ledger_bal_account_no]
				,TARGET.[finance_customer_ledger_bal_account_type]=SOURCE.[finance_customer_ledger_bal_account_type]
				,TARGET.[finance_customer_ledger_closed_by_amount]=SOURCE.[finance_customer_ledger_closed_by_amount]
				,TARGET.[finance_customer_ledger_closed_by_amount_local_currency]=SOURCE.[finance_customer_ledger_closed_by_amount_local_currency]
				,TARGET.[finance_customer_ledger_closed_by_currency_amount]=SOURCE.[finance_customer_ledger_closed_by_currency_amount]
				,TARGET.[finance_customer_ledger_closed_by_currency_code]=SOURCE.[finance_customer_ledger_closed_by_currency_code]
				,TARGET.[finance_customer_ledger_credit_amount]=SOURCE.[finance_customer_ledger_credit_amount]
				,TARGET.[finance_customer_ledger_credit_amount_local_currency]=SOURCE.[finance_customer_ledger_credit_amount_local_currency]
				,TARGET.[finance_customer_ledger_customer_no]=SOURCE.[finance_customer_ledger_customer_no]
				,TARGET.[finance_customer_ledger_customer_posting_group]=SOURCE.[finance_customer_ledger_customer_posting_group]
				,TARGET.[finance_customer_ledger_debit_amount]=SOURCE.[finance_customer_ledger_debit_amount]
				,TARGET.[finance_customer_ledger_description]=SOURCE.[finance_customer_ledger_description]
				,TARGET.[finance_customer_ledger_dimension_set_id]=SOURCE.[finance_customer_ledger_dimension_set_id]
				--,TARGET.[finance_customer_ledger_document_date]=--SOURCE.[finance_customer_ledger_document_date]
				,TARGET.[finance_customer_ledger_document_no]=SOURCE.[finance_customer_ledger_document_no]
				,TARGET.[finance_customer_ledger_document_type]=SOURCE.[finance_customer_ledger_document_type]
				--,TARGET.[finance_customer_ledger_due_date]=--SOURCE.[finance_customer_ledger_due_date]
				,TARGET.[finance_customer_ledger_entry_no]=SOURCE.[finance_customer_ledger_entry_no]
				,TARGET.[finance_customer_ledger_no_series]=SOURCE.[finance_customer_ledger_no_series]
				,TARGET.[finance_customer_ledger_open]=SOURCE.[finance_customer_ledger_open]
				,TARGET.[finance_customer_ledger_original_amount]=SOURCE.[finance_customer_ledger_original_amount]
				,TARGET.[finance_customer_ledger_payment_method_code]=SOURCE.[finance_customer_ledger_payment_method_code]
				,TARGET.[finance_customer_ledger_payment_prediction]=SOURCE.[finance_customer_ledger_payment_prediction]
				,TARGET.[finance_customer_ledger_payment_reference]=SOURCE.[finance_customer_ledger_payment_reference]
				--,TARGET.[finance_customer_ledger_posting_date]=--SOURCE.[finance_customer_ledger_posting_date]
				,TARGET.[finance_customer_ledger_profit_local_currency]=SOURCE.[finance_customer_ledger_profit_local_currency]
				,TARGET.[finance_customer_ledger_reason_code]=SOURCE.[finance_customer_ledger_reason_code]
				,TARGET.[finance_customer_ledger_rem_amt]=SOURCE.[finance_customer_ledger_rem_amt]
				,TARGET.[finance_customer_ledger_rem_amt_for_wht]=SOURCE.[finance_customer_ledger_rem_amt_for_wht]
				,TARGET.[finance_customer_ledger_remaining_amount]=SOURCE.[finance_customer_ledger_remaining_amount]
				,TARGET.[finance_customer_ledger_reversed]=SOURCE.[finance_customer_ledger_reversed]
				,TARGET.[finance_customer_ledger_reversed_entry_no]=SOURCE.[finance_customer_ledger_reversed_entry_no]
				,TARGET.[finance_customer_ledger_sales_local_currency]=SOURCE.[finance_customer_ledger_sales_local_currency]
				,TARGET.[finance_customer_ledger_sell_to_customer_no]=SOURCE.[finance_customer_ledger_sell_to_customer_no]
				,TARGET.[finance_customer_ledger_source_code]=SOURCE.[finance_customer_ledger_source_code]
				,TARGET.[finance_customer_ledger_transaction_no]=SOURCE.[finance_customer_ledger_transaction_no]
				,TARGET.[finance_customer_ledger_user_id]=SOURCE.[finance_customer_ledger_user_id]
				,TARGET.[finance_customer_ledger_withholding_tax_amount]=SOURCE.[finance_customer_ledger_withholding_tax_amount]
				,TARGET.[finance_customer_ledger_withholding_tax_payment]=SOURCE.[finance_customer_ledger_withholding_tax_payment]
				,TARGET.[finance_customer_ledger_ODSEffectiveFrom]=SOURCE.[finance_customer_ledger_ODSEffectiveFrom]
				,TARGET.[DWHSourceSystem] = @SourceSystem
				,TARGET.[DWHModifiedOn] = @systemCurrentDate
				,TARGET.[DWHBatchId] = @BatchID
				,TARGET.[DWHDMLOperation] = 'U'
			 -- Insert new records
	   when not matched by target then 
		insert 
		(
			 finance_customer_ledger_document_date_key
			,finance_customer_ledger_posting_date_key
			,finance_customer_ledger_due_date_key
			,[dim_finance_general_ledger_account_key]
			,[dim_finance_customer_key]
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
			,[fact_finance_customer_ledger_partition_key]
			,[fact_finance_customer_ledger_row_key]
			,[finance_customer_ledger_customer_id]
			,[finance_customer_ledger_budget_holder_id]
			,[finance_customer_ledger_contract_id]
			,[finance_customer_ledger_department_id]
			,[finance_customer_ledger_district_id]
			,[finance_customer_ledger_funder_id]
			,[finance_customer_ledger_funding_agency_id]
			,[finance_customer_ledger_location_id]
			,[finance_customer_ledger_region_id]
			,[finance_customer_ledger_service_id]
			,[finance_customer_ledger_vendor_id]
			,[finance_customer_ledger_company_name]
			,[finance_customer_ledger_amount]
			,[finance_customer_ledger_amount_local_currency]
			,[finance_customer_ledger_bal_account_no]
			,[finance_customer_ledger_bal_account_type]
			,[finance_customer_ledger_closed_by_amount]
			,[finance_customer_ledger_closed_by_amount_local_currency]
			,[finance_customer_ledger_closed_by_currency_amount]
			,[finance_customer_ledger_closed_by_currency_code]
			,[finance_customer_ledger_credit_amount]
			,[finance_customer_ledger_credit_amount_local_currency]
			,[finance_customer_ledger_customer_no]
			,[finance_customer_ledger_customer_posting_group]
			,[finance_customer_ledger_debit_amount]
			,[finance_customer_ledger_description]
			,[finance_customer_ledger_dimension_set_id]
			--,[finance_customer_ledger_document_date]
			,[finance_customer_ledger_document_no]
			,[finance_customer_ledger_document_type]
			--,[finance_customer_ledger_due_date]
			,[finance_customer_ledger_entry_no]
			,[finance_customer_ledger_no_series]
			,[finance_customer_ledger_open]
			,[finance_customer_ledger_original_amount]
			,[finance_customer_ledger_payment_method_code]
			,[finance_customer_ledger_payment_prediction]
			,[finance_customer_ledger_payment_reference]
			--,[finance_customer_ledger_posting_date]
			,[finance_customer_ledger_profit_local_currency]
			,[finance_customer_ledger_reason_code]
			,[finance_customer_ledger_rem_amt]
			,[finance_customer_ledger_rem_amt_for_wht]
			,[finance_customer_ledger_remaining_amount]
			,[finance_customer_ledger_reversed]
			,[finance_customer_ledger_reversed_entry_no]
			,[finance_customer_ledger_sales_local_currency]
			,[finance_customer_ledger_sell_to_customer_no]
			,[finance_customer_ledger_source_code]
			,[finance_customer_ledger_transaction_no]
			,[finance_customer_ledger_user_id]
			,[finance_customer_ledger_withholding_tax_amount]
			,[finance_customer_ledger_withholding_tax_payment]
			,[finance_customer_ledger_ODSEffectiveFrom]
			,[DWHSourceSystem]
			,[DWHBatchId]
			,[DWHDMLOperation]
			,[DWHModifiedOn]
			,[DWHCreatedAt]
		)
		values
		(
			 SOURCE.[finance_customer_ledger_document_date_key]
			,SOURCE.[finance_customer_ledger_posting_date_key]
			,SOURCE.[finance_customer_ledger_due_date_key]
			,SOURCE.[dim_finance_general_ledger_account_key]
			,SOURCE.[dim_finance_customer_key]
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
			,SOURCE.[fact_finance_customer_ledger_partition_key]
			,SOURCE.[fact_finance_customer_ledger_row_key]
			,SOURCE.[finance_customer_ledger_customer_id]
			,SOURCE.[finance_customer_ledger_budget_holder_id]
			,SOURCE.[finance_customer_ledger_contract_id]
			,SOURCE.[finance_customer_ledger_department_id]
			,SOURCE.[finance_customer_ledger_district_id]
			,SOURCE.[finance_customer_ledger_funder_id]
			,SOURCE.[finance_customer_ledger_funding_agency_id]
			,SOURCE.[finance_customer_ledger_location_id]
			,SOURCE.[finance_customer_ledger_region_id]
			,SOURCE.[finance_customer_ledger_service_id]
			,SOURCE.[finance_customer_ledger_vendor_id]
			,SOURCE.[finance_customer_ledger_company_name]
			,SOURCE.[finance_customer_ledger_amount]
			,SOURCE.[finance_customer_ledger_amount_local_currency]
			,SOURCE.[finance_customer_ledger_bal_account_no]
			,SOURCE.[finance_customer_ledger_bal_account_type]
			,SOURCE.[finance_customer_ledger_closed_by_amount]
			,SOURCE.[finance_customer_ledger_closed_by_amount_local_currency]
			,SOURCE.[finance_customer_ledger_closed_by_currency_amount]
			,SOURCE.[finance_customer_ledger_closed_by_currency_code]
			,SOURCE.[finance_customer_ledger_credit_amount]
			,SOURCE.[finance_customer_ledger_credit_amount_local_currency]
			,SOURCE.[finance_customer_ledger_customer_no]
			,SOURCE.[finance_customer_ledger_customer_posting_group]
			,SOURCE.[finance_customer_ledger_debit_amount]
			,SOURCE.[finance_customer_ledger_description]
			,SOURCE.[finance_customer_ledger_dimension_set_id]
			--,SOURCE.[finance_customer_ledger_document_date]
			,SOURCE.[finance_customer_ledger_document_no]
			,SOURCE.[finance_customer_ledger_document_type]
			--,SOURCE.[finance_customer_ledger_due_date]
			,SOURCE.[finance_customer_ledger_entry_no]
			,SOURCE.[finance_customer_ledger_no_series]
			,SOURCE.[finance_customer_ledger_open]
			,SOURCE.[finance_customer_ledger_original_amount]
			,SOURCE.[finance_customer_ledger_payment_method_code]
			,SOURCE.[finance_customer_ledger_payment_prediction]
			,SOURCE.[finance_customer_ledger_payment_reference]
			--,SOURCE.[finance_customer_ledger_posting_date]
			,SOURCE.[finance_customer_ledger_profit_local_currency]
			,SOURCE.[finance_customer_ledger_reason_code]
			,SOURCE.[finance_customer_ledger_rem_amt]
			,SOURCE.[finance_customer_ledger_rem_amt_for_wht]
			,SOURCE.[finance_customer_ledger_remaining_amount]
			,SOURCE.[finance_customer_ledger_reversed]
			,SOURCE.[finance_customer_ledger_reversed_entry_no]
			,SOURCE.[finance_customer_ledger_sales_local_currency]
			,SOURCE.[finance_customer_ledger_sell_to_customer_no]
			,SOURCE.[finance_customer_ledger_source_code]
			,SOURCE.[finance_customer_ledger_transaction_no]
			,SOURCE.[finance_customer_ledger_user_id]
			,SOURCE.[finance_customer_ledger_withholding_tax_amount]
			,SOURCE.[finance_customer_ledger_withholding_tax_payment]
			,SOURCE.[finance_customer_ledger_ODSEffectiveFrom]
			,SOURCE.[DWHSourceSystem]
			,SOURCE.[DWHBatchId]
			,SOURCE.[DWHDMLOperation]
			,SOURCE.[DWHModifiedOn]
			,SOURCE.[DWHCreatedAt]
		);



		-- Get process counts
		select 
			 @targetRecords		= ISNULL(count(1),0)
			,@insertedRecords	= ISNULL(sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end),0)
			,@updatedRecords	= ISNULL(isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end),0)
			,@deletedRecords	= ISNULL(sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end),0)
		from [edw].[fact_finance_customer_ledger]
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
			select  ISNULL(@pErrorRecords,0)	as ErrorRecords,
					ISNULL(@pInsertRecords,0)	as InsertRecords,
					ISNULL(@pUpdateRecords,0)	as UpdateRecords,
					ISNULL(@pDeleteRecords,0)	as DeleteRecords,
					ISNULL(@pCompleted,0)		as Completed,
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