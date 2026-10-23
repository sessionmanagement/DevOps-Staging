
CREATE PROC [staging].[insert_staging_dim_certification]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_certification]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2024-07-04    Manish Singh				Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_certification]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_certification] (
	 [certification_id] 
	,[certification_full_name] 
	,[certification_short_name] 
	,[certification_id_number] 
	,[certification_available_from_date] 
	,[certification_end_date] 
	,[certification_created_date] 
	,[certification_category_id] 
	,[certification_category_name] 
	,[certification_category_path] 
	)
SELECT
	 [certification_id] 
	,[certification_full_name] 
	,[certification_short_name] 
	,[certification_id_number] 
	,[available_from_date] 
	,[certification_end_date] 
	,[certification_created_date] 
	,[certification_category_id] 
	,[certification_category_name] 
	,[certification_category_path] 
from [Landing].[edw_dim_certification]