


CREATE PROC [staging].[insert_staging_dim_region]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_region]
PURPOSE:  Move data from landing.dim_region table into
				[Staging].[ODSETLdim_region]

 Notes: Call By	EDW Pipeline '30_Load_From_ODS'

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2023-06-19    Glenn McLeod		Initial version
1.01	 2023-08-28   Glenn McLeod		Updated table/column names

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_region]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_region] (
	  [region_dimension_value_id]
	, [region_code]
	, [region_name]
	, [region_company_name]
	, [region_last_modified_date_time]
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
from [Landing].[edw_dim_region]