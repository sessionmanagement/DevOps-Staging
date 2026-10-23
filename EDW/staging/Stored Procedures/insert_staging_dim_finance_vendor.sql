


CREATE PROC [staging].[insert_staging_dim_finance_vendor]

AS
/***************************************************************************
NAME:      [staging].[insert_staging_dim_finance_vendor]
PURPOSE:  Move data from landing.dim_finance_vendor table into
				[Staging].[ODSETLdim_finance_vendor] table
				

NOTES: Call By EDW Pipeline ODS_dimvendor-Full Merge

REVISIONS:
Version	 Date		   Author				Description
-------	 ------------  ---------------		--------------------------
1.0		 2023-04-11    Stefen Hasselberg	Initial version
1.1		 2023-08-21	   Glenn McLeod			Rename source tables
1.11	 2023-08-28	   Glenn McLeod			Updated table/column names

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_finance_vendor]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_finance_vendor] (
	  [finance_vendor_dimension_value_id]
	, [finance_vendor_code]
	, [finance_vendor_name]
	, [finance_vendor_company_name]
	, [finance_vendor_last_modified_date_time]
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
from [Landing].[edw_dim_finance_vendor]

-- now do a Binary CheckSum on the Vendor Name and Company Name for any changes
-- as we will use that to identified any changes

UPDATE [staging].[ODSETLdim_finance_vendor] 
SET DimensionCheckSum = BINARY_CHECKSUM(
	[finance_vendor_name]
	, [finance_vendor_company_name]
	)