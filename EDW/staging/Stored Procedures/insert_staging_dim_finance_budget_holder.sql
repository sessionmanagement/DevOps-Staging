




/**********************************************************************************************************
 Procedure	staging.usp_dim_budget_holder_insert
 Author		Stefen Hasselberg
 Created		2023/04/04
 Purpose		Move data from landing.dim_budget_holder table into
				staging.dim_budget_holder table
				

				
 Call By		EDW Pipeline ODS_dimbudget_holder-Full Merge
 Parameter(s)  None 
 =========================================================================================================

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2023-04-04    Stefen Hasselberg		Initial creation of stored procedure
1.1		2023-08-01	  Glenn McLeod			Updated to use table Framework table names 
1.11	2023-08-24	  Glenn McLeod			Updated table/column names

**********************************************************************************************************/


CREATE PROC [staging].[insert_staging_dim_finance_budget_holder]

AS


--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_finance_budget_holder] 

-- insert data from the dim_budget_holder table into the staging table
INSERT INTO [staging].[ODSETLdim_finance_budget_holder](
	  [finance_budget_holder_dimension_value_id]
	, [finance_budget_holder_code]
	, [finance_budget_holder_name]
	, [finance_budget_holder_company_name]
	, [finance_budget_holder_last_modified_date_time]
	, [DWHDMLOperation]
	, [DWHIsCurrent]
	, [DWHEffectiveFrom]
	, [DWHEffectiveTo]
	)
SELECT
	[dimension_value_id]
	, [code]
	, [name]
	, [__CompanyName]
	, [last_modified_date_time]
	, [ODSDMLOperation]
	, [ODSIsCurrent]
	, [ODSEffectiveFrom]
	, [ODSEffectiveTo]
from [landing].[edw_dim_finance_budget_holder]