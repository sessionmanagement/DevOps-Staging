


CREATE PROC [staging].[insert_staging_dim_nationality]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_nationality]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2023-11-30    Glenn McLeod		Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_nationality]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_nationality] (
	 [nationality_id] 
	,[nationality_name] 
	)
SELECT
	 [nationality_id] 
	,[nationality_label] 
from [Landing].[edw_dim_nationality]