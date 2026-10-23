

CREATE PROC [staging].[insert_staging_dim_ethnicity]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_ethnicity]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2023-12-06    Glenn McLeod		Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_ethnicity]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_ethnicity] (
	 [dim_ethnicity_id] 
	,[ethnicity_group] 
	,[ethnicity_level1] 
	,[ethnicity_level2] 
	,[ethnicity_level3] 
	,[ethnicity_level4] 
	,[ethnicity_level5] 
	)
SELECT
	 [ConcatenatedEthnicity] 
	,[ClientEthnicityGrouped] 
	,[ethnicity_level1] 
	,[ethnicity_level2] 
	,[ethnicity_level3] 
	,[ethnicity_level4] 
	,[ethnicity_level5] 
from [Landing].[edw_dim_ethnicity]