
create view [Staging].[vw_On_Call_category]
as 
select
	 src.[category_id] 	,src.[category_name] 	,src.[category_description] 
from [Landing].[On_Call_category] as src;