
create view [Staging].[vw_IntelliHR_skill_disciplines]
as 
select
	 src.[skill_disciplines_id] 	,src.[name] 	,src.[skill_id] 	,src.[skill_name] 
from [Landing].[IntelliHR_skill_disciplines] as src;