


CREATE PROC [staging].[insert_staging_dim_location]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_location]
PURPOSE:  Move data from landing.dim_location table into
				staging.[ODSETLdim_location] table

Notes: Call By	EDW Pipeline '30_Load_From_ODS'


REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2023-04-11    Stefen Hasselberg		Initial creation of stored procedure
1.1		2023-08-04	  Glenn McLeod			Updated to use table Framework table names 
1.11	2023-08-28	  Glenn McLeod			Updated table/column names

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_location]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_location] (
	  [location_dimension_value_id]
	, [location_code]
	, [location_name]
	, [location_company_name]
	, [location_last_modified_date_time]
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
from [Landing].[edw_dim_location]