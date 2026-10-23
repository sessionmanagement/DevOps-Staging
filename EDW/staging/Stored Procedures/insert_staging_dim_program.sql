
CREATE PROC [staging].[insert_staging_dim_program]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_program]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2024-07-04    Manish Singh				Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_program]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_program] (
	 [program_id] 
	,[program_full_name] 
	,[program_short_name] 
	,[program_id_number] 
	,[available_from_date] 
	,[program_end_date] 
	,[program_created_date] 
	,[program_category_id] 
	,[program_category_name] 
	,[program_category_path] 
	)
SELECT
	 [program_id] 
	,[program_full_name] 
	,[program_short_name] 
	,[program_id_number] 
	,[available_from_date] 
	,[program_end_date] 
	,[program_created_date] 
	,[program_category_id] 
	,[program_category_name] 
	,[program_category_path] 
from [Landing].[edw_dim_program]