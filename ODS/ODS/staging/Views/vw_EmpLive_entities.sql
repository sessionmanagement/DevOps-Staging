
create view [Staging].[vw_EmpLive_entities]
as 
select
	 src.[id] 	,src.[name] 	,src.[cost_code] 
from [Landing].[EmpLive_entities] as src;