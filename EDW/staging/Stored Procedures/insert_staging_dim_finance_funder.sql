



CREATE PROC [staging].[insert_staging_dim_finance_funder]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_finance_funder]
PURPOSE:  Move data from landing.dim_finance_funder table into
				staging.dim_finance_funder table

NOTES: Call By		EDW Pipeline ODS_dim_finance_funder-Incremental Merge


REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2023-04-04    Stefen Hasselberg		Initial creation of stored procedure
1.1		2023-08-04	  Glenn McLeod			Updated to use table Framework table names 
1.11	2023-08-21	  Glenn McLeod			Rename source tables
1.12	2023-08-25	  Glenn McLeod			Updated table/column names

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_finance_funder]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_finance_funder] (
	  [finance_funder_dimension_value_id]
	, [finance_funder_code]
	, [finance_funder_name]
	, [finance_funder_company_name]
	, [finance_funder_last_modified_date_time]
	, [DWHDMLOperation]
	, [DWHIsCurrent]
	, [DWHEffectiveFrom]
	, [DWHEffectiveTo]
	)
SELECT
	[dimension_value_id]
	, [code]
	, [name]
	, [__companyname]
	, [last_modified_date_time]
	, [ODSDMLOperation]
	, [ODSIsCurrent]
	, [ODSEffectiveFrom]
	, [ODSEffectiveTo]
from [Landing].[edw_dim_finance_funder]