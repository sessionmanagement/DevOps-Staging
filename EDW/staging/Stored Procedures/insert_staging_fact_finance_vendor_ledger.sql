




CREATE PROC [staging].[insert_staging_fact_finance_vendor_ledger]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_finance_vendor_ledger]
PURPOSE:  

 Notes: Call By	EDW Pipeline '30_Load_From_ODS'

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2023/06/30    Shashi Sharma	 initial creation of stored procedure				
1.1		 2023-08-30	   Glenn McLeod		 Updated to use table Framework table names 
1.11	 2023-08-31	   Glenn McLeod		 Updated table/column names
1.2		 2023-10-27	   Glenn McLeod		 BCCR replacment, convert Bal__Account_Type/Document_Type back to id value

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_finance_vendor_ledger]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_finance_vendor_ledger] (
	[fact_finance_vendor_ledger_partition_key]
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
      
	)
SELECT [PartitionKey]
	,[RowKey]
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
	,[User_ID]
	,[Dimension_Set_ID]
	,[__CompanyName]
	,[Bal__Account_No_]
	--,[Bal__Account_Type]
	,ISNULL(bat.id, - 1) AS [Bal__Account_Type]
	,[Vendor_No_]
	,[Vendor_Name]
	,[Buy_from_Vendor_No_]
	,[Global_Dimension_1_Code]
	,[No__Series]
	,[Open]
	,[Closed_by_Entry_No_]
	,[Document_No_]
	--,[Document_Type]
	,ISNULL(jdt.id, - 1) AS Document_Type
	,[External_Document_No_]
	,[Description]
	,[Payment_Method_Code]
	,[Source_Code]
	,Convert(CHAR(8), [Document_Date], 112)
	,Convert(CHAR(8), [Due_Date], 112)
	,Convert(CHAR(8), [Posting_Date], 112)
	,[Amount]
	,[Amount__LCY_]
	,[Credit_Amount]
	,[Credit_Amount__LCY_]
	,[Closed_by_Amount]
	,[Closed_by_Amount__LCY_]
	,[Closed_by_Currency_Amount]
	,[Original_Amount]
	,[Original_Amt___LCY_]
	,[Purchase__LCY_]
	,[Rem__Amt]
	,[Rem__Amt_for_WHT]
	,[ODSEffectiveFrom]
FROM [Landing].[edw_fact_finance_vendor_ledger] AS fvl
LEFT JOIN (
	SELECT id
		,value
	FROM [reference].[EDW_Mapping]
	WHERE Category = 'Journal_Document_Type'
	) AS jdt ON fvl.[Document_Type] = jdt.Value
LEFT JOIN (
	SELECT id
		,value
	FROM [reference].[EDW_Mapping]
	WHERE Category = 'Journal_Account_Type'
	) AS bat ON fvl.[Bal__Account_Type] = bat.Value