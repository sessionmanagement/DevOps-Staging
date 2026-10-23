
create view [Staging].[vw_IntelliHR_default_remuneration_component]
as 
select
	 src.[default_remuneration_component_id] 	,src.[name] 	,src.[value] 	,src.[isInUse] 	,src.[automaticallyAddToJobs] 	,src.[isEnabled] 	,src.[currency] 	,src.[type] 	,src.[valueType] 
from [Landing].[IntelliHR_default_remuneration_component] as src;