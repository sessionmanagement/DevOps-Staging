







CREATE PROC [staging].[insert_staging_fact_finance_general_ledger]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_finance_general_ledger]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2023/06/23    Shashi Sharma	Initial version
1.1		 2023/06/29	   Shashi Sharma    added customer id field in the table	
1.11	 2023-08-31	   Glenn McLeod		Updated table/column names
1.2		 2023-10-27	   Glenn McLeod		BCCR replacment, convert [Source_Type]/[Document_Type]/[Gen__Posting_Type] back to id value

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_finance_general_ledger]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_finance_general_ledger] (
	[fact_finance_general_ledger_partition_key]
	,[fact_finance_general_ledger_row_key]
	,[finance_budget_holder_id]
	,[finance_contract_id]
	,[finance_customer_id]
	,[department_id]
	,[district_id]
	,[finance_funder_id]
	,[finance_funding_agency_id]
	,[location_id]
	,[region_id]
	,[service_id]
	,[finance_vendor_id]
	,[user_id]
	,[finance_general_ledger_transaction_no]
	,[finance_general_ledger_description]
	,[finance_general_ledger_document_no]
	,[finance_general_ledger_account_no]
	,[finance_general_ledger_source_no]
	,[finance_general_ledger_no_series]
	,[finance_general_ledger_source_code]
	,[finance_general_ledger_source_type]
	,[finance_general_ledger_document_type]
	,[finance_general_ledger_gen_posting_type]
	,[finance_general_ledger_account_name]
	,[finance_general_ledger_gen_bus_posting_group]
	,[finance_general_ledger_gen_prod_posting_group]
	,[finance_general_ledger_global_dimension_1_code]
	,[finance_general_ledger_system_created_entry]
	,[finance_general_ledger_company_name]
	,[finance_posting_date_key]
	,[finance_document_date_key]
	,[finance_general_ledger_last_modified_date_time]
	,[finance_general_ledger_amount]
	,[finance_general_ledger_credit_amount]
	,[finance_general_ledger_debit_amount]
	)
SELECT [PartitionKey]
	,[RowKey]
	,[BUDGET HOLDER]
	,[CONTRACT]
	,[CUSTOMER]
	,[DEPARTMENT]
	,[DISTRICT]
	,[FUNDER]
	,[FUNDING AGENCY]
	,[LOCATE]
	,[REGION]
	,[SERVICE NAME]
	,[VENDOR]
	,[User_ID]
	,[Transaction_No_]
	,[Description]
	,[Document_No_]
	,[G_L_Account_No_]
	,[Source_No_]
	,[No__Series]
	,[Source_Code]
	--,[Source_Type]
	--,[Document_Type]
	--,[Gen__Posting_Type]
	,ISNULL(jst.id, - 1) AS [Source_Type]
	,ISNULL(jdt.id, - 1) AS [Document_Type]
	,ISNULL(gpt.id, - 1) AS [Gen__Posting_Type]
	,[G_L_Account_Name]
	,[Gen__Bus__Posting_Group]
	,[Gen__Prod__Posting_Group]
	,[Global_Dimension_1_Code]
	,[System_Created_Entry]
	,[__CompanyName]
	--,[Posting_Date]
	--,[Document_Date]
	,Convert(CHAR(8), [Posting_Date], 112)
	,Convert(CHAR(8), [Document_Date], 112)
	,[Last_Modified_DateTime]
	,[Amount]
	,[Credit_Amount]
	,[Debit_Amount]
FROM [Landing].[edw_fact_finance_general_ledger] fgl
LEFT JOIN (
	SELECT id
		,value
	FROM [reference].[EDW_Mapping]
	WHERE Category = 'Journal_Source_Type'
	) AS jst ON fgl.[Source_Type] = jst.Value
LEFT JOIN (
	SELECT id
		,value
	FROM [reference].[EDW_Mapping]
	WHERE Category = 'Journal_Document_Type'
	) AS jdt ON fgl.[Document_Type] = jdt.Value
LEFT JOIN (
	SELECT id
		,value
	FROM [reference].[EDW_Mapping]
	WHERE Category = 'Gen_Posting_Type'
	) AS gpt ON fgl.[Gen__Posting_Type] = gpt.Value