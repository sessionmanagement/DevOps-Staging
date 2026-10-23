
create view [Staging].[vw_IntelliHR_training_providers]
as 
select
	 src.[training_providers_id] 	,src.[name] 	,src.[isDefault] 	,src.[isEnabled] 
from [Landing].[IntelliHR_training_providers] as src;