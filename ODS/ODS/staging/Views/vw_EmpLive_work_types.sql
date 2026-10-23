
create view [Staging].[vw_EmpLive_work_types]
as 
select
	 src.[id] 	,src.[name] 	,src.[abbreviation] 	,src.[is_leave] 
from [Landing].[EmpLive_work_types] as src;