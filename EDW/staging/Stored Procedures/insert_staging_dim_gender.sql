
CREATE PROC [staging].[insert_staging_dim_gender]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_gender]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2023-12-04    ?				Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_gender]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_gender] (
	 [gender_id] 
	,[gender_code] 
	,[gender_name] 
	,[intellihr_gender_key] 
	,[datapay_gender_key] 
	,[zavanti_gender_key] 
	,[emplive_gender_key] 
	)
SELECT
	 [gender_id] 
	,[gender_value] 
	,[gender_text] 
	,[intellihr_gender_key] 
	,[datapay_gender_key] 
	,[zavanti_gender_key] 
	,[emplive_gender_key] 
from [Landing].[edw_dim_gender]