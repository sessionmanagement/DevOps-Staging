
create view [Staging].[vw_IntelliHR_employment_conditions]
as 
select
	 src.[employment_conditions_id] 	,src.[name] 	,src.[awardName] 	,src.[isEnabled] 
from [Landing].[IntelliHR_employment_conditions] as src;