


CREATE PROC [staging].[insert_staging_dim_finance_funding_agency]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_finance_funding_agency]
PURPOSE:  Move data from landing.dim_finance_funding_agency table into
				staging.dim_finance_funding_agency table

NOTES: Call By EDW Pipeline ODS_dim_finance_funding_agency-Full Merge

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2023-04-11    Stefen Hasselberg		Initial creation of stored procedure
1.1		2023-08-04	  Glenn McLeod			Updated to use table Framework table names 
1.11	2023-08-21	  Glenn McLeod			Rename source tables
1.12	2023-08-25	  Glenn McLeod			Updated table/column names

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_finance_funding_agency]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_finance_funding_agency] (
	  [finance_funding_agency_dimension_value_id]
	, [finance_funding_agency_code]
	, [finance_funding_agency_name]
	, [finance_funding_agency_company_name]
	, [finance_funding_agency_last_modified_date_time]
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
from [Landing].[edw_dim_finance_funding_agency]