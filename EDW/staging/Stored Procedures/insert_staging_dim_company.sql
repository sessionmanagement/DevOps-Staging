


CREATE PROC [staging].[insert_staging_dim_company]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_company]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2023-08-10    ?				Initial version
1.1		 2023-08-24	   Glenn McLeod		Updated table/column names
1.2		 2023-09-25	   Glenn McLeod		Renamed destination column from [sort_index] to [company_id]

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_company]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_company] (
	 [company_name] 
	,[company_short_code] 
	,[intellihr_company_id] 
	,[datapay_company_id] 
	,[company_datapay_code] 
	--,[sort_index] 
	,[company_id]
	,[company_recordbase_id] 
	,[recordbase_udf_2] 
	,[recordbase_udf_1] 
	)
SELECT
	 [name] 
	,[short_code] 
	,[intellihr_company_id] 
	,[datapay_company_id] 
	,[datapay_code] 
	,[sort_index] 
	,[recordbase_company_id] 
	,[recordbase_udf_2] 
	,[recordbase_udf_1] 
from [Landing].[edw_dim_company]
WHERE [short_code] IS NOT NULL