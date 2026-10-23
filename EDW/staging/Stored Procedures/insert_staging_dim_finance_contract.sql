




/**********************************************************************************************************
 Procedure	staging.usp_dim_finance_contract_insert
 Author		Stefen Hasselberg
 Created		2023/04/04
 Purpose		Move data from landing.dim_finance_contract table into
				staging.dim_finance_contract table
				

				
 Call By	EDW Pipeline '30_Load_From_ODS'
 Parameter(s)  None 
 =========================================================================================================
REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2023-04-11    Stefen Hasselberg		Initial creation of stored procedure
1.1		2023-08-01	  Glenn McLeod			Updated to use table Framework table names 
1.11	2023-08-21	  Glenn McLeod			Rename source tables
1.12	2023-08-24	  Glenn McLeod			Updated table/column names
				
**********************************************************************************************************/


CREATE PROC [staging].[insert_staging_dim_finance_contract]

AS


--  clear the staging table before loading
TRUNCATE TABLE [staging].[ODSETLdim_finance_contract]

-- insert data from the dim_finance_contract table into the staging table
INSERT INTO [staging].[ODSETLdim_finance_contract] (
	  [finance_contract_dimension_value_id]
	, [finance_contract_code]
	, [finance_contract_name]
	, [finance_contract_company_name]
	, [finance_contract_last_modified_date_time]
	, [DWHDMLOperation]
	, [DWHIsCurrent]
	, [DWHEffectiveFrom]
	, [DWHEffectiveTo]
	)
SELECT
	[dimension_value_id]
	, [code]
	, [name]
	, [__companyName]
	, [last_modified_date_time]
	, [ODSDMLOperation]
	, [ODSIsCurrent]
	, [ODSEffectiveFrom]
	, [ODSEffectiveTo]
from [landing].[edw_dim_finance_contract]