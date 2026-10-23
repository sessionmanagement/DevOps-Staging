



CREATE PROC [staging].[insert_staging_fact_finance_budget]

AS


/***************************************************************************
NAME:     [staging].[insert_staging_fact_finance_budget]
PURPOSE:  Move data from [landing].[edw_fact_finance_budget] table into
--				staging.[ODSETLfact_finance_budget] table

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2023/06/30    Shashi Sharma	Initial version
1.1		 2023-09-01	   Glenn McLeod		Updated to use table Framework table names 
1.11	 2023-09-01	   Glenn McLeod		Updated table/column names

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_finance_budget]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_finance_budget] (
	  [fact_finance_budget_partition_key]
      ,[fact_finance_budget_row_key]
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
      ,[finance_budget_company_name]
      ,[finance_budget_general_ledger_account_no]
      ,[finance_budget_dimension_set_id]
      ,[finance_budget_budget_name]
      ,[finance_budget_description]
      ,[finance_budget_global_dimension_1_code]
      ,[finance_budget_entry_no]
      ,[finance_budget_date_key]
      ,[finance_budget_last_modified_date_time]
      ,[finance_budget_amount]
      
	)
SELECT
	   [PartitionKey]
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
      ,[__CompanyName]
      ,[G_L_Account_No_]
      ,[Dimension_Set_ID]
      ,[Budget_Name]
      ,[Description]
      ,[Global_Dimension_1_Code]
      ,[Entry_No_]
      --,[Date]
	  ,Convert(CHAR(8), [Date], 112)
      ,[Last_Date_Modified]
      ,[Amount]
from [Landing].[edw_fact_finance_budget]