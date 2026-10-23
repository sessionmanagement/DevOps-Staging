
create view [Staging].[vw_Akoranga_mdl_certif_completion_history]
as 
select
	 src.[id] 	,src.[certif_id] 	,src.[user_id] 	,src.[certif_path] 	,src.[certif_status] 	,src.[renewal_status] 	,src.[time_window_opens] 	,src.[time_expires] 	,src.[baseline_time_expires] 	,src.[time_completed] 	,src.[time_modified] 	,src.[unassigned] 
from [Landing].[Akoranga_mdl_certif_completion_history] as src;