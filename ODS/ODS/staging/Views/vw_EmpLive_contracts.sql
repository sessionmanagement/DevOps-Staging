
create view [Staging].[vw_EmpLive_contracts]
as 
select
	 src.[id] 	,src.[name] 	,src.[cost_code] 	,src.[comments] 
from [Landing].[EmpLive_contracts] as src;