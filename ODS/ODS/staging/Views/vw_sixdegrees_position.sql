
create view [Staging].[vw_sixdegrees_position]
as 
select
	 src.[position_hierarchy_order_no] 	,src.[position_hierarchy_key] 	,src.[position_hierarchy_code] 	,src.[position_hierarchy_description] 	,src.[position_hierarchy_level_no] 	,src.[position_hierarchy_parent_key] 	,src.[position_hierarchy_ancestor_keys] 	,src.[position_hierarchy_L00_key] 	,src.[position_hierarchy_L01_key] 	,src.[position_hierarchy_L02_key] 	,src.[position_hierarchy_L03_key] 	,src.[position_hierarchy_L04_key] 
from [Landing].[sixdegrees_position] as src;