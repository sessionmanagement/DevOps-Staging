
create view [Staging].[vw_EmpLive_roster_codes]
as 
select
	 src.[id] 	,src.[name] 	,src.[code] 	,src.[sent_code] 	,src.[message] 	,src.[is_working] 
from [Landing].[EmpLive_roster_codes] as src;