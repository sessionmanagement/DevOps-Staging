
create view [Staging].[vw_IntelliHR_position_titles]
as 
select
	 src.[position_title_id] 	,src.[name] 	,src.[isenabled] 	,src.[code] 
from [Landing].[IntelliHR_position_titles] as src;