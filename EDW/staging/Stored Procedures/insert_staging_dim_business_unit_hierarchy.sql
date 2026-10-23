
CREATE PROC [staging].[insert_staging_dim_business_unit_hierarchy]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_business_unit_hierarchy]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2023-12-20    Glenn McLeod		Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_business_unit_hierarchy]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_business_unit_hierarchy] (
	 [business_unit_id] 
	,[business_unit_name] 
	,[business_unit_hierarchy_level1_id] 
	,[business_unit_hierarchy_level1_name] 
	,[business_unit_hierarchy_level2_id] 
	,[business_unit_hierarchy_level2_name] 
	,[business_unit_hierarchy_level3_id] 
	,[business_unit_hierarchy_level3_name] 
	,[business_unit_hierarchy_level4_id] 
	,[business_unit_hierarchy_level4_name] 
	,[business_unit_hierarchy_level5_id] 
	,[business_unit_hierarchy_level5_name] 
	,[business_unit_hierarchy_level6_id] 
	,[business_unit_hierarchy_level6_name] 
	,[business_unit_hierarchy_level7_id] 
	,[business_unit_hierarchy_level7_name] 
	,[business_unit_concatenated_hierarchy] 
	,[is_active_flag] 
	)
SELECT
	 [business_unit_id] 
	,[business_unit_name] 
	,[business_unit_hierarchy_level1_id] 
	,[business_unit_hierarchy_level1_name] 
	,[business_unit_hierarchy_level2_id] 
	,[business_unit_hierarchy_level2_name] 
	,[business_unit_hierarchy_level3_id] 
	,[business_unit_hierarchy_level3_name] 
	,[business_unit_hierarchy_level4_id] 
	,[business_unit_hierarchy_level4_name] 
	,[business_unit_hierarchy_level5_id] 
	,[business_unit_hierarchy_level5_name] 
	,[business_unit_hierarchy_level6_id] 
	,[business_unit_hierarchy_level6_name] 
	,[business_unit_hierarchy_level7_id] 
	,[business_unit_hierarchy_level7_name] 
	,[business_unit_concatenated_hierarchy] 
	,[is_active_flag] 
from [Landing].[edw_dim_business_unit_hierarchy]