
create view [Staging].[vw_IntelliHR_job_requirements]
as 
select
	 src.[job_id] 	,src.[job_requirement_id] 	,src.[startDate] 	,src.[endDate] 	,src.[notifyEmployee] 	,src.[jobRequriementableId] 	,src.[jobRequirementableType] 
from [Landing].[IntelliHR_job_requirements] as src;
GO

