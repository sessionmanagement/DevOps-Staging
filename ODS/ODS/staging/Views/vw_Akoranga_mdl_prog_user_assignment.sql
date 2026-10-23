
create view [Staging].[vw_Akoranga_mdl_prog_user_assignment]
as 
select
	 src.[id] 	,src.[program_id] 	,src.[user_id] 	,src.[assignment_id] 	,src.[time_assigned] 	,src.[exception_status] 
from [Landing].[Akoranga_mdl_prog_user_assignment] as src;