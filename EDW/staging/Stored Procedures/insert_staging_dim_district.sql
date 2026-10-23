

CREATE PROC [staging].[insert_staging_dim_district]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_district]
PURPOSE:  Move data from landing.dim_district table into
				staging.dim_district table

Call By		EDW Pipeline ODS_dim_district-Incremental Merge

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2023-04-11    Stefen Hasselberg		Initial creation of stored procedure
1.1		2023-08-01	  Glenn McLeod			Updated to use table Framework table names 
1.11	2023-08-24	  Glenn McLeod			Updated table/column names

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_district]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_district] (
	  [district_dimension_value_id]
	, [district_code]
	, [district_name]
	, [district_company_name]
	, [district_last_modified_date_time]
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
from [Landing].[edw_dim_district]