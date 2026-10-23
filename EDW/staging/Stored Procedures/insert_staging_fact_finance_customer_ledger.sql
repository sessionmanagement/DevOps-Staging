








CREATE PROC [staging].[insert_staging_fact_finance_customer_ledger]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_finance_customer_ledger]
PURPOSE:  Move data from landing.fact_finance_customer_ledger table into
				staging.fact_finance_customer_ledger table

NOTES: Call By EDW Pipeline '30_Load_From_ODS'

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2023-06-26    Glenn McLeod		Initial version
1.1		 2023-08-09    Glenn McLeod		Updated to use table Framework table names 
1.11	 2023-08-22	   Glenn McLeod		Rename source tables
1.12	 2023-08-29	   Glenn McLeod		Updated table/column names
1.3		 2023-10-27	   Glenn McLeod		BCCR replacment, convert Bal__Account_Type/Document_Type back to id value

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_finance_customer_ledger]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_finance_customer_ledger] (
	[fact_finance_customer_ledger_partition_key]
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
	,[finance_customer_ledger_user_id]
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
	,[finance_customer_ledger_debit_amount_local_currency]
	,[finance_customer_ledger_description]
	,[finance_customer_ledger_dimension_set_id]
	,[finance_customer_ledger_document_date]
	,[finance_customer_ledger_document_no]
	,[finance_customer_ledger_document_type]
	,[finance_customer_ledger_due_date]
	,[finance_customer_ledger_entry_no]
	,[finance_customer_ledger_no_series]
	,[finance_customer_ledger_open]
	,[finance_customer_ledger_original_amount]
	,[finance_customer_ledger_payment_method_code]
	--,[finance_customer_ledger_payment_prediction]
	,[finance_customer_ledger_payment_reference]
	,[finance_customer_ledger_posting_date]
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
	,[finance_customer_ledger_withholding_tax_amount]
	,[finance_customer_ledger_withholding_tax_payment]
	,[finance_customer_ledger_company_name]
	,[finance_customer_ledger_ODSEffectiveFrom]
	)
SELECT [PartitionKey]
	,[RowKey]
	,[CUSTOMER]
	,[BUDGET HOLDER]
	,[CONTRACT]
	,[DEPARTMENT]
	,[DISTRICT]
	,[FUNDER]
	,[FUNDING AGENCY]
	,[LOCATE]
	,[REGION]
	,[SERVICE NAME]
	,[VENDOR]
	--  ,[SERVICE TYPE]
	,[User_ID]
	,[Amount]
	,[Amount__LCY_]
	,[Bal__Account_No_]
	--,[Bal__Account_Type]
	,ISNULL(bat.id, - 1) AS [Bal__Account_Type]
	,[Closed_by_Amount]
	,[Closed_by_Amount__LCY_]
	,[Closed_by_Currency_Amount]
	,[Closed_by_Currency_Code]
	,[Credit_Amount]
	,[Credit_Amount__LCY_]
	,[Customer_No_]
	,[Customer_Posting_Group]
	,[Debit_Amount]
	,[Debit_Amount__LCY_]
	,[Description]
	,[Dimension_Set_ID]
	,[Document_Date]
	,[Document_No_]
	--,[Document_Type]
	,ISNULL(jdt.id, - 1) AS Document_Type
	,[Due_Date]
	,[Entry_No_]
	,[No__Series]
	,[Open]
	,[Original_Amount]
	,[Payment_Method_Code]
	--,[Payment_Prediction]
	,[Payment_Reference]
	,[Posting_Date]
	,[Profit__LCY_]
	,[Reason_Code]
	,[Rem__Amt]
	,[Rem__Amt_for_WHT]
	,[Remaining_Amount]
	,[Reversed]
	,[Reversed_Entry_No_]
	,[Sales__LCY_]
	,[Sell_to_Customer_No_]
	,[Source_Code]
	,[Transaction_No_]
	,[WHT_Amount]
	,[WHT_Payment]
	,[__CompanyName]
	,[ODSEffectiveFrom]
FROM [Landing].[edw_fact_finance_customer_ledger] fcl
LEFT JOIN (
	SELECT id
		,value
	FROM [reference].[EDW_Mapping]
	WHERE Category = 'Journal_Document_Type'
	) AS jdt ON fcl.[Document_Type] = jdt.Value
LEFT JOIN (
	SELECT id
		,value
	FROM [reference].[EDW_Mapping]
	WHERE Category = 'Journal_Account_Type'
	) AS bat ON fcl.[Bal__Account_Type] = bat.Value