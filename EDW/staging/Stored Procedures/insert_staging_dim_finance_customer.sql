

CREATE PROC [staging].[insert_staging_dim_finance_customer]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_finance_customer]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		2023/06/19    Glenn McLeod		Initial creation of stored procedure
1.1		2023-08-01	  Glenn McLeod		Updated to use table Framework table names 
1.11	2023-08-25	  Glenn McLeod			Updated table/column names

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_finance_customer]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_finance_customer] (
	  [finance_customer_dimension_value_id]
	, [finance_customer_code]
	, [finance_customer_name]
	, [finance_customer_company_name]
	, [finance_customer_last_modified_date_time]
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
from [Landing].[edw_dim_finance_customer]