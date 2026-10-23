
create view [Staging].[vw_EmpLive_time_categories]
as 
select
	 src.[id] 	,src.[name] 	,src.[abbreviation] 	,src.[comments] 	,src.[add_to_duration] 
from [Landing].[EmpLive_time_categories] as src;