
create view [Staging].[vw_EmpliveAPI_leave_types]
as 
select
	 src.[leave_type_id] 	,src.[abbreviation] 	,src.[name] 
from [Landing].[EmpliveAPI_leave_types] as src;