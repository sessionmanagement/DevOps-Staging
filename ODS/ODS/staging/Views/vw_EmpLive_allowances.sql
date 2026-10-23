
create view [Staging].[vw_EmpLive_allowances]
as 
select
	 src.[id] 	,src.[name] 	,src.[abbreviation] 	,src.[comments] 
from [Landing].[EmpLive_allowances] as src;