
create view [Staging].[vw_IntelliHR_skills]
as 
select
	 src.[skills_id] 	,src.[name] 	,src.[description] 	,src.[isBusinessCritical] 	,src.[skillDisciplineId] 	,src.[skillDisciplineName] 
from [Landing].[IntelliHR_skills] as src;