
create view [Staging].[vw_EmpliveAPI_leave_codes]
as 
select
	 src.[leave_code] 	,src.[name] 
from [Landing].[EmpliveAPI_leave_codes] as src;